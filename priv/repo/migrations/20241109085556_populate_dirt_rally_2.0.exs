defmodule RacingLeaderboards.Repo.Migrations.PopulateDirtRally2 do
  use Ecto.Migration

  import Ecto.Query
  import Ecto.Multi

  alias RacingLeaderboards.Cars.Car
  alias RacingLeaderboards.Games
  alias RacingLeaderboards.Circuits.Circuit
  alias RacingLeaderboards.Repo

  def up do
    now = DateTime.utc_now() |> DateTime.truncate(:second) |> IO.inspect(label: "time now")

    game = Games.get_game_by_code!("dirt-rally-2.0")

    circuits =
      with {:ok, body} <- File.read("priv/repo/seeds/dirt-rally-2.0-locations.json"),
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
              name: circuit_name,
              distance: distance,
              inserted_at: now,
              updated_at: now
            }
          end)
        end)
      end
      |> IO.inspect(label: "circuits")

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all_dirt_rally_2_circuits, Circuit, circuits)
    |> Repo.transaction()

    cars =
      with {:ok, body} <- File.read("priv/repo/seeds/dirt-rally-2.0-cars.json"),
           {:ok, json} <- Jason.decode(body) do
        json
        |> Enum.flat_map(fn group ->
          class = group["category"]

          group["cars"]
          |> Enum.flat_map(fn car_group ->
            type = car_group["type"]

            car_group["vehicles"]
            |> Enum.map(fn vehicle ->
              %{
                game_id: game.id,
                name: vehicle,
                class: class,
                inserted_at: now,
                updated_at: now
              }
            end)
          end)
        end)
      end
      |> IO.inspect(label: "cars")

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all_dirt_rally_2_cars, Car, cars)
    |> Repo.transaction()
  end

  def down do
    game = Games.get_game_by_code!("dirt-rally-2.0")
    circuits = from(c in Circuit, where: c.game_id == ^game.id)

    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_all_dirt_rally_2_circuits, circuits)
    |> Repo.transaction()

    query = from(c in Circuit, where: c.game_id == ^game.id)

    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_all_dirt_rally_2_cars, query)
    |> Repo.transaction()
  end
end
