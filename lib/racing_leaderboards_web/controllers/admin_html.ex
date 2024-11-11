defmodule RacingLeaderboardsWeb.AdminHTML do
  use RacingLeaderboardsWeb, :html

  def home(assigns) do
    ~H"""
    <.header>
      Admin page
    </.header>

    <ul>
      <li>
        <a href="/users">Users</a>
      </li>
      <li>
        <a href="/circuits">Circuits</a>
      </li>
      <li>
        <a href="/games">Games</a>
      </li>
    </ul>
    """
  end
end
