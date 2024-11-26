defmodule RacingLeaderboardsWeb.ChangelogController do
  use RacingLeaderboardsWeb, :controller

  def home(conn, _params) do
    changes = [
      {"201de79", "chore: Version bump to 0.2.0"},
      {"64f12a5", "fix: Record form redirection + patch URL"},
      {"72f77b6", "refactor: Convert records.time to postgres time; reflect UI changes"},
      {"a3c0a48", "feat: redirect_to handling + version bump"},
      {"7565800", "fix: Week record_click to use correct record id"},
      {"53199d9", "feat: Row click events for date/week records"},
      {"d799384", "fix: Sort by fastest times first"},
      {"0ff34ec", "docs: Add DB bootstrap instructions"},
      {"0aae951", "chore: Upgrade Dockerfile"},
      {"089ff29", "refactor: Change seed files"},
      {"324448d", "refactor: Recreate migrations using hardcoded data inside the elixir files"},
      {"2278597", "chore: Remove IO.inspects"},
      {"a1b5a10", "fix: Parse date on date.html.heex"},
      {"e97a58d", "feat: Search by date + better UI"},
      {"9564c9d", "feat: v0.1.0 finalized"},
      {"9c797a6", "feat: UI tweaks + modifications to DB types"},
      {"ffd559b", "refactor: Remove unused JS"},
      {"f7ae38b", "feat: Dedicated daily/weekly pages; UI styling"},
      {"071349e", "feat: Home page + thumbnails"},
      {"1f3d5cf", "feat: Cars + users + biz logic"},
      {"0e6c485", "refactor: Remove @spec and unused code"},
      {"19dc130", "feat: Initial commit"}
    ]

    render(conn, :home, %{changes: changes})
  end
end
