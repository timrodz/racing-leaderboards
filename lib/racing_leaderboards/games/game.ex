defmodule RacingLeaderboards.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :code, :string
    field :url, :string
    field :display_name, :string
    field :image_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:display_name, :code, :url, :image_url])
    |> validate_required([:display_name, :code])
  end
end
