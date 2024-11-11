defmodule RacingLeaderboardsWeb.PageController do
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    games = Games.list_games()
    render(conn, :home, %{layout: false, games: games})
  end
end
