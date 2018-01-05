defmodule ItsAPartyWeb.Router do
  use ItsAPartyWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ItsAPartyWeb do
    # Use the default browser stack
    pipe_through(:browser)
    resources("/contacts", ContactController)
    get("/login", SessionController, :new)
    post("/login", SessionController, :create)
    delete("/logout", SessionController, :delete)
    get("/", PageController, :index)
  end

  scope "/admin", ItsAPartyWeb.Admin, as: :admin do
    pipe_through([:browser, ItsAPartyWeb.Plugs.AuthorizeAdmin])
    resources("/users", UserController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ItsAPartyWeb do
  #   pipe_through :api
  # end
end