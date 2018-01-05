defmodule ItsAPartyWeb.SessionController do
  use ItsAPartyWeb, :controller
  @accounts Application.get_env(:its_a_party, :accounts)

  plug(ItsAPartyWeb.Plugs.CurrentUser when action in [:delete])

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case @accounts.authenticate_by_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "You are now signed in.")
        |> redirect(to: page_path(conn, :index))

      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Could not find a user with that email.")
        |> render("new.html")

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Email or password are incorrect.")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    delete_session(conn, :current_user_id)
    |> put_flash(:info, "You have been logged out")
    |> redirect(to: session_path(conn, :new))
  end
end