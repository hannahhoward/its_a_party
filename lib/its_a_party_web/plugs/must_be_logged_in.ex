defmodule ItsAPartyWeb.Plugs.MustBeLoggedIn do
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

      true ->
        conn
    end
  end
end