defmodule RacingLeaderboards.Circuits.Circuit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "circuits" do
    field :country, :string
    field :region, :string
    field :display_name, :string
    field :distance, :decimal
    field :surface, :string
    field :image_url, :string

    field :game_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(map, attrs) do
    map
    |> cast(attrs, [:country, :region, :display_name, :distance, :surface, :image_url])
    |> validate_required([:region, :display_name, :distance])
  end
end
