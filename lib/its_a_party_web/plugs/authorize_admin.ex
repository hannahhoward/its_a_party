defmodule ItsAPartyWeb.Plugs.AuthorizeAdmin do
  use Plug.Builder

  plug(ItsAPartyWeb.Plugs.CurrentUser)
  plug(ItsAPartyWeb.Plugs.MustBeLoggedIn)
  plug(ItsAPartyWeb.Plugs.MustBeAdmin)
end