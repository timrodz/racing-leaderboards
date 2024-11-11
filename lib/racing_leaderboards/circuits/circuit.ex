defmodule RacingLeaderboards.Circuits.Circuit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "circuits" do
    field :country, :string
    field :region, :string
    field :name, :string
    field :distance, :decimal
    field :surface, :string
    field :image_url, :string

    belongs_to :game, RacingLeaderboards.Games.Game

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(map, attrs) do
    map
    |> cast(attrs, [:country, :region, :name, :distance, :surface, :image_url, :game_id])
    |> validate_required([:region, :name, :distance, :game_id])
  end
end
