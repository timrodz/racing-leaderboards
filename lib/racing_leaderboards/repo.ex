defmodule RacingLeaderboards.Repo do
  use Ecto.Repo,
    otp_app: :racing_leaderboards,
    adapter: Ecto.Adapters.Postgres
end
