# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RacingLeaderboards.Repo.insert!(%RacingLeaderboards.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# use Ecto.Migration

# import Ecto.Multi
# import Ecto.Migration

# alias RacingLeaderboards.Circuits.Circuit
# alias RacingLeaderboards.Games.Game
# alias RacingLeaderboards.Games
# alias RacingLeaderboards.Repo

# now = DateTime.utc_now() |> DateTime.truncate(:second) |> IO.inspect(label: "time now")

# inserted_games =
#   Ecto.Multi.new()
#   |> Ecto.Multi.insert_all(:insert_all_games, Game, [
#     %{
#       code: "wrc-24",
#       display_name: "EA SPORTS™ WRC 24",
#       url: "https://www.ea.com/games/ea-sports-wrc/wrc-24",
#       image_url: "/thumbnails/wrc-24",
#       inserted_at: now,
#       updated_at: now
#     },
#     %{
#       code: "dirt-rally-2.0",
#       display_name: "DiRT Rally 2.0",
#       url: "https://dirtrally2.dirtgame.com/",
#       image_url: "/thumbnails/dirt-rally-2.0",
#       inserted_at: now,
#       updated_at: now
#     }
#   ])
#   |> Repo.transaction()

# # Ecto.Migration.flush()

# dirt_rally_2 = Games.get_game_by_code!("dirt-rally-2.0")

# dirt_rally_2_list_circuits =
#   with {:ok, body} <- File.read("priv/repo/seeds/locations-dirt-rally-2.0.json"),
#        {:ok, json} <- Jason.decode(body) do
#     json
#     |> Enum.flat_map(fn location ->
#       country = location["country"]
#       region = location["region"]

#       location["stages"]
#       |> Enum.map(fn stage ->
#         circuit = stage["circuit"]
#         distance = stage["distance"]

#         %{
#           game_id: dirt_rally_2.id,
#           country: country,
#           region: region,
#           circuit: circuit,
#           distance: distance,
#           inserted_at: now,
#           updated_at: now
#         }
#       end)
#     end)
#   end
#   |> IO.inspect()

# inserted_list_circuits_dirt_rally_2 =
#   Ecto.Multi.new()
#   |> Ecto.Multi.insert_all(:insert_all_dirt_rally_2_list_circuits, Circuit, dirt_rally_2_list_circuits)
#   |> Repo.transaction()
