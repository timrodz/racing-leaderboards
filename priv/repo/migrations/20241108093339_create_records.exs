defmodule RacingLeaderboards.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records) do
      add :date, :date
      add :time, :string
      add :is_dnf, :boolean, default: false, null: false
      add :is_verified, :boolean, default: false, null: false
      add :game_id, references(:games, on_delete: :delete_all)
      add :circuit_id, references(:circuits, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      add :car_id, references(:cars, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:records, [:game_id])
    create index(:records, [:circuit_id])
    create index(:records, [:car_id])
    create index(:records, [:user_id])
  end
end
