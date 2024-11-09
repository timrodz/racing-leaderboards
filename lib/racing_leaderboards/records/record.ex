defmodule RacingLeaderboards.Records.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :date, :date
    field :time, :string
    field :user, :string
    field :is_dnf, :boolean, default: false
    field :is_verified, :boolean, default: false

    field :game_id, :id
    field :map_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:user, :time, :date, :is_dnf, :is_verified])
    |> validate_required([:user, :time, :date])
  end
end
