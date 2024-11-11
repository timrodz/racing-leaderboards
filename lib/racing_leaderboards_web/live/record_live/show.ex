defmodule RacingLeaderboardsWeb.RecordLive.Show do
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Games
  alias RacingLeaderboards.Records

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"game_code" => game_code, "id" => id}, _, socket) do
    game = Games.get_game_by_code!(game_code)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game_id, game.id)
     |> assign(:game_code, game.code)
     |> assign(:record, Records.get_record!(id))}
  end

  defp page_title(:show), do: "Show Record"
  defp page_title(:edit), do: "Edit Record"
end
