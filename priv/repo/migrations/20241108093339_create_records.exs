defmodule RacingLeaderboards.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records) do
      add :user, :string
      add :date, :date
      add :time, :string
      add :is_dnf, :boolean, default: false, null: false
      add :is_verified, :boolean, default: false, null: false
      add :game_id, references(:games, on_delete: :nothing)
      add :circuit_id, references(:circuits, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:records, [:game_id])
    create index(:records, [:circuit_id])
  end
end
