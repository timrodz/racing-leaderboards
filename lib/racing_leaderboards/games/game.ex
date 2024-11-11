defmodule RacingLeaderboards.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :code, :string
    field :url, :string
    field :name, :string
    field :image_url, :string

    has_many :circuits, RacingLeaderboards.Circuits.Circuit
    has_many :cars, RacingLeaderboards.Cars.Car

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name, :code, :url, :image_url])
    |> validate_required([:name, :code])
  end
end
