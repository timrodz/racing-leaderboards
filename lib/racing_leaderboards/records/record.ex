defmodule RacingLeaderboards.Records.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :date, :date
    field :time, :time_usec
    field :is_dnf, :boolean, default: false
    field :is_verified, :boolean, default: false

    belongs_to :game, RacingLeaderboards.Games.Game
    belongs_to :user, RacingLeaderboards.Users.User
    belongs_to :circuit, RacingLeaderboards.Circuits.Circuit
    belongs_to :car, RacingLeaderboards.Cars.Car

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(record, attrs) do
    # Prepends 00: at the start of the time if the user doesn't input the hour
    # This is so that they don't have to do this tedious task over and over
    attrs =
      with true <- Map.has_key?(attrs, "time"),
           false <- is_nil(attrs["time"]),
           # Length 5 because the minimum required time is "mm:ss"
           false <- attrs["time"] |> String.length() < 5,
           # If there are 3 colons in the string, that means the time is in the format "hh:mm:ss"
           false <- String.split(attrs["time"], ":") |> length() == 3 do
        attrs
        |> Map.replace!("time", "00:#{attrs["time"]}")
      else
        _ ->
          attrs
      end

    record
    |> cast(attrs, [
      :time,
      :date,
      :is_dnf,
      :is_verified,
      :game_id,
      :user_id,
      :circuit_id,
      :car_id
    ])
    |> validate_required([:time, :date, :is_dnf, :game_id, :user_id, :circuit_id, :car_id])
    |> validate_select(:user_id, "Please select an user")
    |> validate_select(:circuit_id, "Please select a circuit")
    |> validate_select(:car_id, "Please select a car")
  end

  defp validate_select(changeset, field, error) do
    id = get_field(changeset, field)

    case id do
      # -1 means it's not found in the select options
      -1 -> add_error(changeset, field, error)
      _ -> changeset
    end
  end
end
