defmodule ItsAPartyWeb.Plugs.AuthorizeAdmin do
  @accounts Application.get_env(:its_a_party, :accounts)
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller

  @impl true
  def init(default), do: default

  @impl true
  def call(conn, _) do
    cond do
      conn.assigns[:current_user] == nil ->
        conn
        |> put_flash(:error, 'You need to be signed in to view this page')
        |> redirect(to: ItsAPartyWeb.Router.Helpers.session_path(conn, :new))
        |> halt

      @accounts.is_admin?(conn.assigns[:current_user]) == false ->
        conn
        |> put_flash(:error, 'You do not have sufficient privileges view this page')
        |> redirect(to: ItsAPartyWeb.Router.Helpers.page_path(conn, :index))
        |> halt

      true ->
        conn
    end
  end
end