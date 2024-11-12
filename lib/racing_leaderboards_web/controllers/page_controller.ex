defmodule RacingLeaderboardsWeb.PageController do
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :controller

  def home(conn, _params) do
    games = Games.list_games()
    date = NaiveDateTime.local_now() |> NaiveDateTime.to_date() |> Date.to_string()
    render(conn, :home, %{layout: false, games: games, date: date})
  end
end
