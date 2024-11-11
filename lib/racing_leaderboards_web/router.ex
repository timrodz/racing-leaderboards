defmodule RacingLeaderboardsWeb.Router do
  use RacingLeaderboardsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RacingLeaderboardsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RacingLeaderboardsWeb do
    pipe_through :browser

    get "/", PageController, :home

    # USERS
    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit

    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit

    # GAMES
    live "/games", GameLive.Index, :index
    live "/games/new", GameLive.Index, :new
    live "/games/:id/edit", GameLive.Index, :edit

    live "/games/:id", GameLive.Show, :show
    live "/games/:id/show/edit", GameLive.Show, :edit

    # CIRCUITS
    live "/circuits", CircuitLive.Index, :index
    live "/circuits/new", CircuitLive.Index, :new
    live "/circuits/:id/edit", CircuitLive.Index, :edit

    live "/circuits/:id", CircuitLive.Show, :show
    live "/circuits/:id/show/edit", CircuitLive.Show, :edit

    # CARS
    live "/cars", CarLive.Index, :index
    live "/cars/new", CarLive.Index, :new
    live "/cars/:id/edit", CarLive.Index, :edit

    live "/cars/:id", CarLive.Show, :show
    live "/cars/:id/show/edit", CarLive.Show, :edit

    # RECORDS
    live "/games/:game_code/records", RecordLive.Index, :index
    live "/games/:game_code/records/new", RecordLive.Index, :new
    live "/games/:game_code/records/:id/edit", RecordLive.Index, :edit

    live "/games/:game_code/records/:id", RecordLive.Show, :show
    live "/games/:game_code/records/:id/show/edit", RecordLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", RacingLeaderboardsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:racing_leaderboards, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RacingLeaderboardsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
