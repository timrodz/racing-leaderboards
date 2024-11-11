defmodule RacingLeaderboards.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :code, :string
      add :name, :string
      add :url, :string
      add :image_url, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:games, [:code])
  end
end
