defmodule RacingLeaderboardsWeb.RecordsForGameController do
  alias RacingLeaderboards.Records
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :controller

  def by_date(conn, %{"date" => date, "game_code" => game_code}) do
    render(conn, "date.html", get_records_for_date(date, game_code, "Records for #{date}"))
  end

  def daily(conn, %{"game_code" => game_code}) do
    today = NaiveDateTime.local_now() |> NaiveDateTime.to_date() |> Date.to_string()
    render(conn, "date.html", get_records_for_date(today, game_code, "Daily Challenge"))
  end

  def by_week(conn, %{"date" => date, "game_code" => game_code}) do
    render(conn, "week.html", get_records_for_week(date, game_code, "Week #{date}"))
  end

  def weekly(conn, %{"game_code" => game_code}) do
    today = NaiveDateTime.local_now() |> NaiveDateTime.to_date() |> Date.to_string()
    render(conn, "week.html", get_records_for_week(today, game_code, "Weekly challenge"))
  end

  defp get_records_for_date(date, game_code, page_title) do
    game =
      Games.get_game_by_code!(game_code)

    records = Records.list_records_by_game_date(game.id, date)

    grouped_records =
      records
      |> Enum.group_by(&{&1.circuit, &1.car})

    %{
      page_title: page_title,
      game: game,
      date: date,
      grouped_records: grouped_records
    }
  end

  defp get_records_for_week(date, game_code, page_title) do
    game =
      Games.get_game_by_code!(game_code)

    records = Records.list_records_by_game_week(game.id, date)

    grouped_records =
      records
      |> Enum.group_by(&{&1.date, &1.circuit, &1.car})
      |> Enum.sort_by(
        fn {{date, _circuit, _car}, _records} -> date end,
        :desc
      )

    grouped_records_by_date =
      records
      |> Enum.group_by(&{&1.circuit, &1.car})
      |> IO.inspect(label: "HI")

    %{
      page_title: page_title,
      game: game,
      grouped_records: grouped_records
    }
  end
end
