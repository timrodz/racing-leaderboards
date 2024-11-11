defmodule RacingLeaderboards.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :name, :string
      add :class, :string
      add :horsepower, :string
      add :weight, :string
      add :powertrain_type, :string
      add :transmision_type, :string
      add :engine_type, :string
      add :aspiration_type, :string
      add :game_id, references(:games, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:cars, [:game_id])
  end
end
