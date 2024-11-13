defmodule RacingLeaderboardsWeb.CircuitLive.Index do
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Circuits
  alias RacingLeaderboards.Circuits.Circuit

  @impl true
  def mount(params, _session, socket) do
    game = Games.get_game_by_code!(params["game_code"])

    {:ok,
     socket
     |> stream(:circuits, Circuits.list_circuits_by_game(game.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Circuit")
    |> assign(:circuit, Circuits.get_circuit!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Circuit")
    |> assign(:circuit, %Circuit{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Circuits")
    |> assign(:circuit, nil)
  end

  @impl true
  def handle_info({RacingLeaderboardsWeb.CircuitLive.FormComponent, {:saved, map}}, socket) do
    {:noreply, stream_insert(socket, :circuits, map)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    map = Circuits.get_circuit!(id)
    {:ok, _} = Circuits.delete_circuit(map)

    {:noreply, stream_delete(socket, :circuits, map)}
  end
end
