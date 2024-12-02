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
    time |> Time.truncate(:millisecond) |> Time.to_iso8601()
  end

  def parse_time_diff(time) do
    time_string = time |> Time.truncate(:millisecond) |> Time.to_iso8601()

    [hour, minutes, seconds] = String.split(time_string, ":")

    "+#{if hour == "00", do: nil, else: "#{hour}:"}#{minutes}:#{seconds}"
  end
end
