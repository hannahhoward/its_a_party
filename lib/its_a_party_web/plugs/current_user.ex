defmodule ItsAPartyWeb.Plugs.CurrentUser do
  @accounts Application.get_env(:its_a_party, :accounts)
  @behaviour Plug
  import Plug.Conn

  @impl true
  def init(default), do: default

  @impl true
  def call(conn, _) do
    case get_session(conn, :current_user_id) do
      nil -> assign(conn, :current_user, nil)
      user_id -> assign(conn, :current_user, @accounts.get_user!(user_id))
    end
  end
end