defmodule RacingLeaderboardsWeb.GameLive.Show do
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Games

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"game_code" => code}, _, socket) do
    today = NaiveDateTime.local_now() |> NaiveDateTime.to_date()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game, Games.get_game_by_code!(code))
     |> assign_new(:form, fn ->
       to_form(%{"date" => today})
     end)}
  end

  defp page_title(:show), do: "Show Game"
  defp page_title(:edit), do: "Edit Game"

  @impl true
  def handle_event("search", %{"date" => date}, socket) do
    {:noreply,
     socket |> push_navigate(to: ~p"/games/#{socket.assigns.game.code}/records/date/#{date}")}
  end
end
