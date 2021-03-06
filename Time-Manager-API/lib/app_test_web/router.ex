defmodule AppTestWeb.Router do
  use AppTestWeb, :router

  pipeline :browser do
    plug CORSPlug, origin: "*"
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
  end

  pipeline :api do
    plug CORSPlug, origin: "*"
    ###########################################
#    plug :fetch_session
#    plug :put_csrf_token_in_session
#    plug Plug.CSRFProtection
#    plug :protect_from_forgery
    ###########################################
    plug :accepts, ["json"]
  end

#  defp put_csrf_token_in_session(conn, _) do
#    Plug.CSRFProtection.get_csrf_token
#    conn |> put_session("_csrf_token", Plug.CSRFProtection.get_csrf_token)
#  end

  scope "/", AppTestWeb do
    pipe_through :browser
    get "/", PageController, :index
  end

#  #AUTHENTIFICATION
#  scope "/auth", AppTestWeb do
#    #USERS
#    post "/users/sign_up", UsersController, :sign_up
#    post "/users/sign_in", UsersController, :sign_in
#  end

  #NEED TO BE AUTHENTICATED TO USE THESE ROUTES
   scope "/api", AppTestWeb do
     pipe_through :api

     #USERS
     post "/users/sign_up", UsersController, :sign_up
     post "/users/sign_in", UsersController, :sign_in
     options "/users", UsersController, :options
     resources "/users", UsersController, except: [:new, :edit]

     #WORKINGTIMES
     post("/workingtimes/:usersId", WorkingtimesController, :create)
     get("/workingtimes/:usersId/:id", WorkingtimesController, :show)
     get("/workingtimes/:usersId", WorkingtimesController, :index)
     put("/workingtimes/:id", WorkingtimesController, :update)
     delete("/workingtimes/:id", WorkingtimesController, :delete)

     #CLOCKS
     post("/clocks/:usersId", ClocksController, :create)
     get("/clocks/:usersId", ClocksController, :show)
     delete("/clocks/:id", ClocksController, :delete)

    #TEAMS
     post("/teams", TeamsController, :create)
     get("/teams", TeamsController, :index)
     post("/teamsUsers", TeamsController, :addUsersInTeams)

    #post "/workingtimes/:usersid", WorkingtimesController, :create
   end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AppTestWeb.Telemetry
    end
  end
end
