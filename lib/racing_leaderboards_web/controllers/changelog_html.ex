defmodule RacingLeaderboardsWeb.ChangelogHTML do
  use RacingLeaderboardsWeb, :html

  def home(assigns) do
    ~H"""
    <.header>
      Changelog
    </.header>
    <hr />
    <div class="pt-6">
      <ul>
        <%= for {hash, message} <- @changes do %>
          <li>
            <p>
              <.link
                href={"https://github.com/timrodz/racing-leaderboards/commit/#{hash}"}
                target="_blank"
              >
                <span class="font-mono">
                  <%= hash %>
                </span>
              </.link>
              <%= message %>
            </p>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
