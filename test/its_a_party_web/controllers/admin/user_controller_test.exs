defmodule ItsAPartyWeb.Admin.UserControllerTest do
  use ItsAPartyWeb.ConnCase
  alias ItsAParty.AccountsMock
  alias ItsAParty.Accounts.User
  import ItsAPartyWeb.LoginHelpers
  import Mox

  @create_attrs %{first_name: "some first_name", last_name: "some last_name", roles: []}
  @update_attrs %{
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    roles: []
  }
  @invalid_attrs %{first_name: nil, last_name: nil, roles: nil}

  setup :verify_on_exit!

  describe "index" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = get(conn, admin_user_path(conn, :index))
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in as non admin redirects to root", %{conn: conn} do
      conn =
        conn
        |> sign_in_as_non_admin
        |> get(admin_user_path(conn, :index))

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "when logged in as admin it lists all users", %{conn: conn} do
      AccountsMock
      |> expect(:list_users, fn -> [%User{id: 1}, %User{id: 2}] end)

      conn =
        conn
        |> sign_in_as_admin
        |> get(admin_user_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = get(conn, admin_user_path(conn, :new))
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in as non admin redirects to root", %{conn: conn} do
      conn =
        conn
        |> sign_in_as_non_admin
        |> get(admin_user_path(conn, :new))

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "when logged in as admin renders form", %{conn: conn} do
      AccountsMock
      |> expect(:change_user, fn _ -> User.changeset(%User{}, %{}) end)

      conn =
        conn
        |> sign_in_as_admin
        |> get(admin_user_path(conn, :new))

      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = post(conn, admin_user_path(conn, :create), user: @create_attrs)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in as non admin redirects to root", %{conn: conn} do
      conn =
        conn
        |> sign_in_as_non_admin
        |> post(admin_user_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "when logged in as admin redirects to show when data is valid", %{conn: conn} do
      AccountsMock
      |> expect(:create_user, fn _ -> {:ok, %User{id: 1}} end)

      conn =
        conn
        |> sign_in_as_admin
        |> post(admin_user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_user_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      AccountsMock
      |> expect(:create_user, fn _ -> {:error, User.changeset(%User{}, %{})} end)

      conn =
        conn
        |> sign_in_as_admin
        |> post(admin_user_path(conn, :create), user: @invalid_attrs)

      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = get(conn, admin_user_path(conn, :edit, %User{id: 1}))
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in as non admin redirects to root", %{conn: conn} do
      conn =
        conn
        |> sign_in_as_non_admin
        |> get(admin_user_path(conn, :edit, %User{id: 1}))

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "when logged in as admin renders form for editing chosen user", %{conn: conn} do
      AccountsMock
      |> expect(:change_user, fn u -> User.changeset(u, %{}) end)
      |> expect(:get_user!, fn id -> %User{id: id} end)

      conn =
        conn
        |> sign_in_as_admin
        |> get(admin_user_path(conn, :edit, %User{id: 1}))

      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = put(conn, admin_user_path(conn, :update, %User{id: 1}), user: @update_attrs)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in as non admin redirects to root", %{conn: conn} do
      conn =
        conn
        |> sign_in_as_non_admin
        |> put(admin_user_path(conn, :update, %User{id: 1}), user: @update_attrs)

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "when logged in as admin redirects when data is valid", %{conn: conn} do
      AccountsMock
      |> expect(:update_user, fn u, _params -> {:ok, u} end)
      |> expect(:get_user!, fn id -> %User{id: id} end)

      conn =
        conn
        |> sign_in_as_admin
        |> put(admin_user_path(conn, :update, %User{id: 1}), user: @update_attrs)

      assert redirected_to(conn) == admin_user_path(conn, :show, %User{id: 1})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      AccountsMock
      |> expect(:update_user, fn u, params -> {:error, User.changeset(u, params)} end)
      |> expect(:get_user!, fn id -> %User{id: id} end)

      conn =
        conn
        |> sign_in_as_admin
        |> put(admin_user_path(conn, :update, %User{id: 1}), user: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    test "when not logged in it redirects to login", %{conn: conn} do
      conn = delete(conn, admin_user_path(conn, :delete, %User{id: 1}))
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "when logged in as non admin redirects to root", %{conn: conn} do
      conn =
        conn
        |> sign_in_as_non_admin
        |> delete(admin_user_path(conn, :delete, %User{id: 1}))

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "deletes chosen user", %{conn: conn} do
      AccountsMock
      |> expect(:delete_user, fn u -> {:ok, u} end)
      |> expect(:get_user!, fn id -> %User{id: id} end)

      conn =
        conn
        |> sign_in_as_admin
        |> delete(admin_user_path(conn, :delete, %User{id: 1}))

      assert redirected_to(conn) == admin_user_path(conn, :index)
    end
  end
end