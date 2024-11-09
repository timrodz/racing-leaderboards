defmodule RacingLeaderboards.Repo.Migrations.PopulateCircuitsWrc24 do
  use Ecto.Migration

  import Ecto.Query
  import Ecto.Multi

  alias RacingLeaderboards.Games
  alias RacingLeaderboards.Circuits.Circuit
  alias RacingLeaderboards.Repo

  def up do
    now = DateTime.utc_now() |> DateTime.truncate(:second) |> IO.inspect(label: "time now")

    game = Games.get_game_by_code!("wrc-24")

    circuits =
      with {:ok, body} <- File.read("priv/repo/seeds/locations-wrc-24.json"),
           {:ok, json} <- Jason.decode(body) do
        json
        |> Enum.map(fn stage ->
          %{
            game_id: game.id,
            country: stage["country"],
            region: stage["region"],
            display_name: stage["display_name"],
            distance: stage["distance"],
            surface: stage["surface"],
            inserted_at: now,
            updated_at: now
          }
        end)
      end
      |> IO.inspect()

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all_wrc_24_circuits, Circuit, circuits)
    |> Repo.transaction()
  end

  def down do
    game = Games.get_game_by_code!("wrc-24")
    query = from(c in Circuit, where: c.game_id == ^game.id)

    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_all_wrc_24_circuits, query)
    |> Repo.transaction()
  end
end
