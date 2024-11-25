defmodule RacingLeaderboardsWeb.RecordLive.Show do
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Games
  alias RacingLeaderboards.Records

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"game_code" => game_code, "id" => id} = params, _, socket) do
    game = Games.get_game_by_code!(game_code)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(game: game, redirect_to: params["redirect_to"])
     |> assign(:record, Records.get_record!(id))}
  end

  defp page_title(:show), do: "Show Record"
  defp page_title(:edit), do: "Edit Record"

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    record = Records.get_record!(id)
    {:ok, _} = Records.delete_record(record)

    {:noreply,
     socket
     |> put_flash(:info, "Record deleted successfully")
     |> push_patch(to: ~p"/games/#{socket.assigns.game_code}/records")}
  end
end
