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

import Ecto.Multi
import Ecto.Migration

alias RacingLeaderboards.Users.User
alias RacingLeaderboards.Circuits.Circuit
alias RacingLeaderboards.Games.Game
alias RacingLeaderboards.Games
alias RacingLeaderboards.Repo

now = DateTime.utc_now() |> DateTime.truncate(:second) |> IO.inspect(label: "time now")

user_names =
  [
    "Juan M",
    "Jason W",
    "Tim J",
    "Michael X",
    "Matt S",
    "Jonathon H",
    "Oscar J",
    "Alice L",
    "Meng H",
    "Matthew D"
  ]
  |> Enum.map(fn name ->
    %{
      name: name,
      inserted_at: now,
      updated_at: now
    }
  end)

inserted_games =
  Ecto.Multi.new()
  |> Ecto.Multi.insert_all(:insert_all, User, user_names)
  |> Repo.transaction()
