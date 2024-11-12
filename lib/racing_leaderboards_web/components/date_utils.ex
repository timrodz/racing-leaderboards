defmodule RacingLeaderboards.DateUtils do
  @doc """
  Requires {:calendar, "~> 1.0.0"}
  """

  @day_of_week_names {"Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"}
  @month_names {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto",
                "Septiembre", "Octubre", "Noviembre", "Diciembre"}

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

  defp parse(dt, format) do
    Calendar.strftime(
      dt,
      format,
      day_of_week_names: fn day_of_week -> @day_of_week_names |> elem(day_of_week - 1) end,
      month_names: fn month -> @month_names |> elem(month - 1) end
    )
  end
end
