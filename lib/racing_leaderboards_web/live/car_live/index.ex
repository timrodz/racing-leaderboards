defmodule RacingLeaderboardsWeb.CarLive.Index do
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Cars
  alias RacingLeaderboards.Cars.Car

  @impl true
  def mount(%{"game_code" => game_code}, _session, socket) do
    game = Games.get_game_by_code!(game_code)

    {:ok,
     socket
     |> assign(game: game)
     |> stream(:cars, Cars.list_cars())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Car")
    |> assign(:car, Cars.get_car!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Car")
    |> assign(:car, %Car{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cars")
    |> assign(:car, nil)
  end

  @impl true
  def handle_info({RacingLeaderboardsWeb.CarLive.FormComponent, {:saved, car}}, socket) do
    {:noreply, stream_insert(socket, :cars, car)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    car = Cars.get_car!(id)
    {:ok, _} = Cars.delete_car(car)

    {:noreply, stream_delete(socket, :cars, car)}
  end
end
