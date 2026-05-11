defmodule RacingLeaderboardsWeb.RecordsForGameController do
  use RacingLeaderboardsWeb, :controller

  alias RacingLeaderboardsWeb.DateUtils
  alias RacingLeaderboards.Records
  alias RacingLeaderboards.Games

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

  def weekly_stats(conn, %{"date" => date, "game_code" => game_code}) do
    parsed_date =
      case Date.from_iso8601(date) do
        {:ok, parsed_date} -> parsed_date
        _ -> NaiveDateTime.local_now() |> NaiveDateTime.to_date()
      end

    game = Games.get_game_by_code!(game_code)

    combinations = Records.get_fastest_records_by_game_week_combinations(game.id, date)

    processed_combinations =
      combinations
      |> Enum.map(fn {circuit, car, fastest_record, all_records} ->
        {circuit, car, fastest_record, process_records(all_records)}
      end)

    grouped_records = process_weekly_combinations(processed_combinations)

    render(conn, "weekly_stats.html", %{
      page_title: "Weekly Stats for #{game.name} - Week of #{DateUtils.parse(parsed_date)}",
      game: game,
      date: parsed_date,
      grouped_records: grouped_records
    })
  end

  defp get_records_for_date(date_string, game_code, page_title) do
    date =
      case Date.from_iso8601(date_string) do
        {:ok, parsed_date} -> parsed_date
        _ -> NaiveDateTime.local_now() |> NaiveDateTime.to_date()
      end

    game =
      Games.get_game_by_code!(game_code)

    records =
      Records.list_records_by_game_date(game.id, date_string)

    %{
      page_title: page_title,
      game: game,
      date: date,
      records: process_records(records)
    }
  end

  defp get_records_for_week(date_string, game_code, page_title) do
    date =
      case Date.from_iso8601(date_string) do
        {:ok, parsed_date} -> parsed_date
        _ -> NaiveDateTime.local_now() |> NaiveDateTime.to_date()
      end

    game =
      Games.get_game_by_code!(game_code)

    records = Records.list_records_by_game_week(game.id, date_string)

    # iterate between start_of_week and finish at end_of_week
    # And map records to every date, even if there aren't any records
    records_by_date = records |> Enum.group_by(& &1.date)

    grouped_records_by_date =
      Date.range(Date.beginning_of_week(date), Date.end_of_week(date))
      |> Enum.map(fn range_date ->
        case records_by_date |> Map.get(range_date) do
          nil ->
            {range_date, nil}

          records ->
            {range_date, process_records(records)}
        end
      end)

    %{
      page_title: page_title,
      game: game,
      records: grouped_records_by_date
    }
  end

  # Maps records by circuit and car, and then calculate diff times
  defp process_records(records) do
    fastest_time =
      case length(records) do
        0 ->
          Time.from_iso8601!("00:00:00.000")

        _ ->
          records |> Enum.min_by(& &1.time, Time) |> Map.get(:time)
      end

    records
    |> Enum.group_by(&{&1.circuit, &1.car})
    |> Enum.map(fn {{circuit, car}, records} ->
      {
        {circuit, car},
        records |> Enum.map(&enrich_record(&1, fastest_time))
      }
    end)
  end

  # Adds a diff_time field to the record
  defp enrich_record(record, fastest_time) do
    diff = Time.diff(record.time, fastest_time, :millisecond)

    case diff do
      0 ->
        record |> Map.put(:diff_time, nil)

      _ ->
        diff_time = Time.from_iso8601!("00:00:00.000") |> Time.add(diff, :millisecond)
        record |> Map.put(:diff_time, diff_time)
    end
  end

  # Process combinations for weekly stats view
  defp process_weekly_combinations(combinations) do
    combinations
    |> Enum.filter(fn {_circuit, _car, _fastest_record, grouped_records} ->
      grouped_records != nil and length(grouped_records) > 0
    end)
    |> Enum.map(fn {circuit, car, _fastest_record, grouped_records} ->
      all_records =
        grouped_records
        |> Enum.flat_map(fn {{^circuit, ^car}, records} -> records end)

      # Separate finished records from DNFs
      finished_records =
        all_records
        |> Enum.filter(fn record -> not record.is_dnf end)
        |> Enum.sort_by(fn record -> record.time end)

      dnf_records =
        all_records
        |> Enum.filter(fn record -> record.is_dnf end)
        |> Enum.sort_by(fn record -> record.time end)

      {circuit, car, finished_records, dnf_records}
    end)
    |> Enum.filter(fn {_circuit, _car, finished_records, dnf_records} ->
      length(finished_records) > 0 or length(dnf_records) > 0
    end)
  end
end
