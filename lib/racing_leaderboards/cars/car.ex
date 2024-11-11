defmodule RacingLeaderboards.Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cars" do
    field :name, :string
    field :class, :string
    field :horsepower, :string
    field :weight, :string
    field :powertrain_type, :string
    field :transmision_type, :string
    field :engine_type, :string
    field :aspiration_type, :string

    belongs_to :game, RacingLeaderboards.Games.Game
    has_many :records, RacingLeaderboards.Records.Record

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, [
      :name,
      :class,
      :horsepower,
      :weight,
      :powertrain_type,
      :transmision_type,
      :engine_type,
      :aspiration_type
    ])
    |> validate_required([:name, :class])
  end
end
