defmodule RacingLeaderboardsWeb.DailyChallengeController do
  alias RacingLeaderboards.Records
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :controller

  def by_date(conn, %{"date" => date, "game_code" => game_code}) do
    render(conn, "date.html", get_records_for_date(date, game_code))
  end

  def daily(conn, %{"game_code" => game_code}) do
    today = NaiveDateTime.local_now() |> NaiveDateTime.to_date() |> Date.to_string()
    render(conn, "date.html", get_records_for_date(today, game_code))
  end

  def weekly(conn, %{"game_code" => game_code}) do
    today = NaiveDateTime.local_now() |> NaiveDateTime.to_date() |> Date.to_string()
    render(conn, "week.html", get_records_for_week(today, game_code))
  end

  def by_week(conn, %{"date" => date, "game_code" => game_code}) do
    render(conn, "week.html", get_records_for_week(date, game_code))
  end

  defp get_records_for_date(date, game_code) do
    game =
      Games.get_game_by_code!(game_code)

    records = Records.list_records_by_date(date)

    grouped_records =
      records
      |> Enum.group_by(&{&1.circuit, &1.car})

    %{
      game: game,
      date: date,
      records: records,
      grouped_records: grouped_records
    }
  end

  defp get_records_for_week(date, game_code) do
    game =
      Games.get_game_by_code!(game_code)

    records = Records.list_records_by_week(date)

    grouped_records =
      records
      |> Enum.group_by(&{&1.date, &1.circuit, &1.car})
      |> Enum.sort_by(
        fn {{date, _circuit, _car}, _records} -> date end,
        :desc
      )

    %{
      game: game,
      date: date,
      records: records,
      grouped_records: grouped_records
    }
  end
end
