defmodule ItsAPartyWeb.SessionControllerTest do
  use ItsAPartyWeb.ConnCase
  alias ItsAParty.AccountsMock
  alias ItsAParty.Accounts.User
  import Mox
  import Plug.Test
  import ItsAPartyWeb.LoginHelpers

  @email "bilbo@bilbo.com"
  @password "password12"
  @session_params %{"session" => %{"email" => @email, "password" => @password}}
  setup :verify_on_exit!

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, session_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign In"
    end
  end

  describe "create session" do
    test "with valid login", %{conn: conn} do
      user = %User{id: 1}

      AccountsMock
      |> expect(:authenticate_by_email_and_password, fn _email, _password -> {:ok, user} end)

      conn =
        conn
        |> init_test_session(%{})
        |> post(session_path(conn, :create), @session_params)

      assert get_session(conn, :current_user_id) == 1
      assert get_flash(conn, :info) == "You are now signed in."
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "renders errors when not found", %{conn: conn} do
      AccountsMock
      |> expect(:authenticate_by_email_and_password, fn _email, _password ->
           {:error, :not_found}
         end)

      conn =
        conn
        |> init_test_session(%{})
        |> post(session_path(conn, :create), @session_params)

      assert get_session(conn, :current_user_id) == nil
      assert get_flash(conn, :error) == "Could not find a user with that email."
      assert html_response(conn, 200) =~ "Sign In"
    end

    test "renders errors when unauthorized", %{conn: conn} do
      AccountsMock
      |> expect(:authenticate_by_email_and_password, fn _email, _password ->
           {:error, :unauthorized}
         end)

      conn =
        conn
        |> init_test_session(%{})
        |> post(session_path(conn, :create), @session_params)

      assert get_session(conn, :current_user_id) == nil
      assert get_flash(conn, :error) == "Email or password are incorrect."
      assert html_response(conn, 200) =~ "Sign In"
    end
  end

  describe "delete session" do
    test "removes user from session and goes to login", %{conn: conn} do
      conn =
        sign_in(conn, %User{id: 1})
        |> delete(session_path(conn, :delete))

      assert get_session(conn, :current_user_id) == nil
      assert get_flash(conn, :info) == "You have been logged out"
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end