defmodule RacingLeaderboards.Repo.Migrations.PopulateCircuitsDirtRally2 do
  use Ecto.Migration

  import Ecto.Query
  import Ecto.Multi

  alias RacingLeaderboards.Games
  alias RacingLeaderboards.Circuits.Circuit
  alias RacingLeaderboards.Repo

  def up do
    now = DateTime.utc_now() |> DateTime.truncate(:second) |> IO.inspect(label: "time now")

    game = Games.get_game_by_code!("dirt-rally-2.0")

    circuits =
      with {:ok, body} <- File.read("priv/repo/seeds/locations-dirt-rally-2.0.json"),
           {:ok, json} <- Jason.decode(body) do
        json
        |> Enum.flat_map(fn location ->
          country = location["country"]
          region = location["region"]

          location["stages"]
          |> Enum.map(fn stage ->
            circuit_name = stage["circuit"]
            distance = stage["distance"]

            %{
              game_id: game.id,
              country: country,
              region: region,
              display_name: circuit_name,
              distance: distance,
              inserted_at: now,
              updated_at: now
            }
          end)
        end)
      end
      |> IO.inspect()

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all_dirt_rally_2_circuits, Circuit, circuits)
    |> Repo.transaction()
  end

  def down do
    game = Games.get_game_by_code!("dirt-rally-2.0")
    query = from(c in Circuit, where: c.game_id == ^game.id)

    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_all_dirt_rally_2_circuits, query)
    |> Repo.transaction()
  end
end
