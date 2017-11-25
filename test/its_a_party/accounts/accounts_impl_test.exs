defmodule ItsAParty.AccountsImplTest do
  use ItsAParty.DataCase

  alias ItsAParty.Accounts.AccountsImpl, as: Accounts

  describe "users" do
    alias ItsAParty.Accounts.User

    @password "applesauce"
    @invalid_password "cheese"
    @invalid_email "bilbo@bilbo.com"
    @valid_attrs %{
      first_name: "some first_name",
      last_name: "some last_name",
      roles: [],
      credential: %{
        email: "apples@apples.com",
        password: @password,
        password_confirmation: @password
      }
    }
    @update_attrs %{
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      roles: []
    }
    @invalid_attrs %{first_name: nil, last_name: nil, roles: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      Accounts.get_user!(user.id)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.roles == []
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.roles == []
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "authenticate_by_email_and_password with a valid email+password returns the user" do
      user = user_fixture()

      assert {:ok, user} ==
               Accounts.authenticate_by_email_and_password(user.credential.email, @password)
    end

    test "authenticate_by_email_and_password given an invalid email returns not found" do
      user_fixture()

      assert {:error, :not_found} =
               Accounts.authenticate_by_email_and_password(@invalid_email, @password)

      assert {:error, :not_found} = Accounts.authenticate_by_email_and_password(nil, @password)
    end

    test "authenticate_by_email_and_password given an invalid password returns not authorized" do
      user = user_fixture()

      assert {:error, :unauthorized} =
               Accounts.authenticate_by_email_and_password(
                 user.credential.email,
                 @invalid_password
               )
    end
  end
end