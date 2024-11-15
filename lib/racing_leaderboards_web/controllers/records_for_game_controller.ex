defmodule RacingLeaderboardsWeb.RecordsForGameController do
  alias RacingLeaderboardsWeb.DateUtils
  alias RacingLeaderboards.Records
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :controller

  def by_date(conn, %{"date" => date, "game_code" => game_code}) do
    dt = DateUtils.parse(Date.from_iso8601!(date))

    render(
      conn,
      "date.html",
      get_records_for_date(
        date,
        game_code,
        "Records for #{dt}"
      )
    )
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

  defp get_records_for_date(date_string, game_code, page_title) do
    game =
      Games.get_game_by_code!(game_code)

    records =
      Records.list_records_by_game_date(game.id, date_string)

    grouped_records =
      records
      |> Enum.group_by(&{&1.circuit, &1.car})

    date =
      case Date.from_iso8601(date_string) do
        {:ok, parsed_date} -> parsed_date
        _ -> NaiveDateTime.local_now() |> NaiveDateTime.to_date()
      end

    %{
      page_title: page_title,
      game: game,
      date: date,
      date_parsed: DateUtils.parse(date),
      grouped_records: grouped_records
    }
  end

  defp get_records_for_week(date_string, game_code, page_title) do
    game =
      Games.get_game_by_code!(game_code)

    records = Records.list_records_by_game_week(game.id, date_string)

    # I'm creating an iterator between the start of the week and the end of the week
    # I'm then iterating over the records and grouping them by date
    # This is so that I can show entries on the weekly page and users can directly add to it

    date =
      case Date.from_iso8601(date_string) do
        {:ok, parsed_date} -> parsed_date
        _ -> NaiveDateTime.local_now() |> NaiveDateTime.to_date()
      end

    start_of_week = Date.beginning_of_week(date)
    end_of_week = Date.end_of_week(date)

    # iterate between start_of_week and finish at end_of_week
    records_by_date =
      records
      |> Enum.group_by(& &1.date)
      |> IO.inspect(label: "BY DATE")

    iterated_dates =
      Date.range(start_of_week, end_of_week)
      |> Enum.map(fn day ->
        case records_by_date
             |> Map.get(day) do
          nil ->
            IO.puts("NO ENTRY FOR #{day}")
            {day, nil}

          r ->
            IO.puts("YES ENTRY FOR #{day}")
            {day, r |> Enum.group_by(&{&1.circuit, &1.car})}
        end
      end)

    %{
      page_title: page_title,
      game: game,
      iterated_dates: iterated_dates
    }
  end
end
