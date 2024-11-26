defmodule RacingLeaderboardsWeb.DateUtils do
  def render_naive_datetime(dt) do
    NaiveDateTime.to_string(dt)
  end

  def render_naive_datetime_date(dt) do
    parse(dt, "%A %d de %B del %Y")
  end

  def render_naive_datetime_full(dt) do
    parse(
      dt,
      "%A %d de %B del %Y @ %I:%M %p"
    )
  end

  def parse(dt) do
    Calendar.strftime(dt, "%A %d %B %Y")
  end

  def parse(dt, format) do
    Calendar.strftime(dt, format)
  end

  def parse_time(time) do
    hours = time.hour |> Integer.to_string() |> String.pad_leading(2, "0")
    minutes = time.minute |> Integer.to_string() |> String.pad_leading(2, "0")
    seconds = time.second |> Integer.to_string() |> String.pad_leading(2, "0")

    {ms, _precision} = time.microsecond

    miliseconds =
      "#{ms |> Integer.to_string() |> String.pad_trailing(2, "0") |> String.slice(0, 3)}"

    case time.hour == 0 do
      true -> "#{minutes}:#{seconds}.#{miliseconds}"
      false -> "#{hours}:#{minutes}:#{seconds}.#{miliseconds}"
    end
  end
end
