defmodule RacingLeaderboardsWeb.CircuitLive.Index do
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Circuits
  alias RacingLeaderboards.Circuits.Circuit

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(games: Games.list_games() |> Enum.into(%{}, fn game -> {game.id, game} end))
     |> stream(:circuits, Circuits.list_circuits())}
  end

  @impl true
  @spec handle_params(any(), any(), %{
          :assigns => atom() | %{:live_action => :edit | :index | :new, optional(any()) => any()},
          optional(any()) => any()
        }) :: {:noreply, map()}
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
