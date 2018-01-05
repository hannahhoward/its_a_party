defmodule ItsAPartyWeb.Plugs.AuthorizeUser do
  use Plug.Builder

  plug(ItsAPartyWeb.Plugs.CurrentUser)
  plug(ItsAPartyWeb.Plugs.MustBeLoggedIn)
end