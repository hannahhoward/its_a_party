defmodule ItsAPartyWeb.Admin.UserControllerTest do
  use ItsAPartyWeb.ConnCase
  alias ItsAParty.AccountsMock
  alias ItsAParty.Accounts.User
  import Mox
  
  @create_attrs %{first_name: "some first_name", last_name: "some last_name", roles: []}
  @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name", roles: []}
  @invalid_attrs %{first_name: nil, last_name: nil, roles: nil}

  setup :verify_on_exit!

  describe "index" do
    test "lists all users", %{conn: conn} do
      AccountsMock
      |> expect(:list_users, fn -> [%User{id: 1}, %User{id: 2}] end)
      
      conn = get conn, admin_user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      AccountsMock
      |> expect(:change_user, fn _ -> User.changeset(%User{}, %{}) end)
      
      conn = get conn, admin_user_path(conn, :new)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      AccountsMock
      |> expect(:create_user, fn _ -> {:ok, %User{id: 1}} end)
      conn = post conn, admin_user_path(conn, :create), user: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_user_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      AccountsMock
      |> expect(:create_user, fn _ -> {:error, User.changeset(%User{}, %{})} end)
      
      conn = post conn, admin_user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    test "renders form for editing chosen user", %{conn: conn} do
      AccountsMock
      |> expect(:change_user, fn u -> User.changeset(u, %{}) end)
      |> expect(:get_user!, fn id -> %User{id: id} end)

      conn = get conn, admin_user_path(conn, :edit, %User{id: 1})
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do

    test "redirects when data is valid", %{conn: conn} do
      AccountsMock
      |> expect(:update_user, fn u, _params -> {:ok, u} end)
      |> expect(:get_user!, fn id -> %User{id: id} end)

      conn = put conn, admin_user_path(conn, :update, %User{id: 1}), user: @update_attrs
      assert redirected_to(conn) == admin_user_path(conn, :show, %User{id: 1})

    end

    test "renders errors when data is invalid", %{conn: conn} do
      AccountsMock
      |> expect(:update_user, fn u, params -> {:error, User.changeset(u, params) } end)
      |> expect(:get_user!, fn id -> %User{id: id} end)

      conn = put conn, admin_user_path(conn, :update, %User{id: 1}), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do

    test "deletes chosen user", %{conn: conn} do
      AccountsMock
      |> expect(:delete_user, fn u -> {:ok, u} end)
      |> expect(:get_user!, fn id -> %User{id: id} end)

      conn = delete conn, admin_user_path(conn, :delete, %User{id: 1})
      assert redirected_to(conn) == admin_user_path(conn, :index)
    end
  end
end
