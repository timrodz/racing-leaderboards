defmodule RacingLeaderboards.Repo.Migrations.PopulateGames do
  use Ecto.Migration

  import Ecto.Multi

  alias RacingLeaderboards.Games.Game
  alias RacingLeaderboards.Repo

  def up do
    now = DateTime.utc_now() |> DateTime.truncate(:second) |> IO.inspect(label: "time now")

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all_games, Game, [
      %{
        code: "dirt-rally-2.0",
        name: "DiRT Rally 2.0",
        url: "https://dirtrally2.dirtgame.com/",
        image_url: "thumbnails/dirt-rally-2.0.jpg",
        inserted_at: now,
        updated_at: now
      },
      %{
        code: "wrc-24",
        name: "EA SPORTS™ WRC 24",
        url: "https://www.ea.com/games/ea-sports-wrc/wrc-24",
        image_url: "thumbnails/wrc-24.jpg",
        inserted_at: now,
        updated_at: now
      }
    ])
    |> Repo.transaction()
  end

  def down do
    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_all_games, Game)
    |> Repo.transaction()
  end
end
