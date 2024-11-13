defmodule RacingLeaderboards.Records.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :date, :date
    field :time, :string
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
    record
    |> cast(attrs, [:time, :date, :is_dnf, :is_verified, :game_id, :user_id, :circuit_id, :car_id])
    |> validate_required([:time, :date, :is_dnf, :game_id, :user_id, :circuit_id, :car_id])
    |> validate_select(:user_id, "Please select an user")
    |> validate_select(:circuit_id, "Please select a circuit")
    |> validate_select(:car_id, "Please select a car")
    |> validate_time()
  end

  defp validate_select(changeset, field, error) do
    id = get_field(changeset, field)

    case id do
      # -1 means it's not found in the select options
      -1 -> add_error(changeset, field, error)
      _ -> changeset
    end
  end

  defp validate_time(changeset) do
    time = get_field(changeset, :time)

    with false <- is_nil(time),
         [minutes, seconds] <- String.split(time, ":"),
         {_m, ""} <- Float.parse(minutes),
         {_s, ""} <- Float.parse(seconds) do
      changeset
    else
      _ ->
        add_error(changeset, :time, "Time doesn't have the correct format (mm:ss)")
    end
  end
end
