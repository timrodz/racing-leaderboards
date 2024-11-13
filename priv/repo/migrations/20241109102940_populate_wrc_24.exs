defmodule RacingLeaderboards.Repo.Migrations.PopulateWrc24 do
  use Ecto.Migration

  import Ecto.Query
  import Ecto.Multi

  alias RacingLeaderboards.Cars.Car
  alias RacingLeaderboards.Games
  alias RacingLeaderboards.Circuits.Circuit
  alias RacingLeaderboards.Repo

  def up do
    now = DateTime.utc_now() |> DateTime.truncate(:second) |> IO.inspect(label: "time now")

    game = Games.get_game_by_code!("wrc-24")

    circuits =
      with {:ok, body} <- File.read("priv/repo/seeds/wrc-24-locations.json"),
           {:ok, json} <- Jason.decode(body) do
        json
        |> Enum.map(fn stage ->
          %{
            game_id: game.id,
            country: stage["country"],
            region: stage["region"],
            name: stage["name"],
            distance: stage["distance"],
            surface: stage["surface"],
            inserted_at: now,
            updated_at: now
          }
        end)
      end
      |> IO.inspect(label: "circuits")

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all_wrc_24_circuits, Circuit, circuits)
    |> Repo.transaction()

    cars =
      with {:ok, body} <- File.read("priv/repo/seeds/wrc-24-cars.json"),
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
                sub_class: type,
                inserted_at: now,
                updated_at: now
              }
            end)
          end)
        end)
      end
      |> IO.inspect(label: "cars")

    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:insert_all_wrc_24_cars, Car, cars)
    |> Repo.transaction()
  end

  def down do
    game = Games.get_game_by_code!("wrc-24")
    circuits = from(c in Circuit, where: c.game_id == ^game.id)

    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_all_wrc_24_circuits, circuits)
    |> Repo.transaction()

    cars = from(c in Car, where: c.game_id == ^game.id)

    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:delete_all_wrc_24_cars, cars)
    |> Repo.transaction()
  end
end
