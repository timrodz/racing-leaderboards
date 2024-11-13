defmodule RacingLeaderboardsWeb.GameLive.Show do
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Games

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"game_code" => code}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game, Games.get_game_by_code!(code))}
  end

  defp page_title(:show), do: "Show Game"
  defp page_title(:edit), do: "Edit Game"
end
