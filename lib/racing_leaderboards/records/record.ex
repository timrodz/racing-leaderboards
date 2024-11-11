defmodule RacingLeaderboards.Records.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :date, :date
    field :time, :string
    field :is_dnf, :boolean, default: false
    field :is_verified, :boolean, default: false

    belongs_to :user, RacingLeaderboards.Users.User
    belongs_to :circuit, RacingLeaderboards.Circuits.Circuit
    belongs_to :car, RacingLeaderboards.Cars.Car

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:time, :date, :is_dnf, :is_verified, :user_id, :circuit_id, :car_id])
    |> IO.inspect(label: "cast")
    |> validate_required([:time, :date, :is_dnf, :user_id, :circuit_id, :car_id])
    |> IO.inspect(label: "changeset")
    |> validate_user_entry()
    |> validate_time()
  end

  defp validate_user_entry(changeset) do
    user_id = get_field(changeset, :user_id)

    case user_id do
      -1 -> add_error(changeset, :user_id, "Please select an user")
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
