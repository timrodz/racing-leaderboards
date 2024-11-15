# mix run priv/repo/seeds.exs

import Ecto.Multi
import Ecto.Query
import Ecto.Migration

alias RacingLeaderboards.Users.User
alias RacingLeaderboards.Circuits.Circuit
alias RacingLeaderboards.Games.Game
alias RacingLeaderboards.Games
alias RacingLeaderboards.Repo

now = DateTime.utc_now() |> DateTime.truncate(:second)

user_names =
  [
    "Juan M"
  ]
  |> Enum.map(fn name ->
    %{
      name: name,
      inserted_at: now,
      updated_at: now
    }
  end)
