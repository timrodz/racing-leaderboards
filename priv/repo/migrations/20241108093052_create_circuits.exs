defmodule RacingLeaderboards.Repo.Migrations.CreateCircuits do
  use Ecto.Migration

  def change do
    create table(:circuits) do
      add :country, :string
      add :region, :string
      add :name, :string
      add :distance, :decimal
      add :surface, :string
      add :image_url, :string
      add :game_id, references(:games, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:circuits, [:game_id])
  end
end
