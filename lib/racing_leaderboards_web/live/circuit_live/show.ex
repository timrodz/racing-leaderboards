defmodule RacingLeaderboardsWeb.CircuitLive.Show do
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Circuits

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:circuit, Circuits.get_circuit!(id))}
  end

  defp page_title(:show), do: "Show Circuit"
  defp page_title(:edit), do: "Edit Circuit"
end
