defmodule ItsAPartyWeb.PageController do
  use ItsAPartyWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
