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
end
