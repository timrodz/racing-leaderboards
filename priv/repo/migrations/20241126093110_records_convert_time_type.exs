defmodule RacingLeaderboards.Repo.Migrations.RecordsConvertTimeType do
  alias RacingLeaderboards.Records
  use Ecto.Migration

  import Ecto.Query

  def up do
    # Set "field :time, :time_usec" in record.ex
    # Add "field :time_old, :string" in record.ex

    rename table(:records), :time, to: :time_old

    alter table(:records) do
      add :time, :time_usec
    end

    flush()

    Records.list_records()
    |> Enum.each(
      &Records.update_record(&1, %{time: convert_string_time_to_time_usec(&1.time_old)})
    )

    flush()

    alter table(:records) do
      remove :time_old
    end
  end

  def down do
    # Set "field :time, :string" in record.ex

    alter table(:records) do
      modify :time, :string
    end

    flush()

    Records.list_records()
    |> Enum.each(&Records.update_record(&1, %{time: convert_time_usec_to_string_time(&1.time)}))
  end

  defp convert_string_time_to_time_usec(time) do
    [minutes, seconds] = String.split(time, ":")
    minutes = minutes |> String.pad_leading(2, "0")
    seconds = seconds |> String.pad_leading(2, "0")

    Time.from_iso8601!("00:#{minutes}:#{seconds}")
  end

  defp convert_time_usec_to_string_time(time) do
    [hours, minutes, seconds] = String.split(time, ":")
    minutes = minutes |> String.pad_leading(2, "0")
    seconds = seconds |> String.pad_leading(2, "0")

    case hours do
      "00" -> "#{minutes}:#{seconds}"
      _ -> "#{hours}:#{minutes}:#{seconds}"
    end
  end
end
