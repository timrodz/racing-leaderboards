defmodule RacingLeaderboardsWeb.CarLive.Show do
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Cars

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "game_code" => game_code}, _, socket) do
    game = Games.get_game_by_code!(game_code)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game, game)
     |> assign(:car, Cars.get_car!(id))}
  end

  defp page_title(:show), do: "Show Car"
  defp page_title(:edit), do: "Edit Car"
end
