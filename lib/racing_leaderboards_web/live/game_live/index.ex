defmodule RacingLeaderboardsWeb.GameLive.Index do
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Games
  alias RacingLeaderboards.Games.Game

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :games, Games.list_games())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"game_code" => code}) do
    socket
    |> assign(:page_title, "Edit Game")
    |> assign(:game, Games.get_game!(code))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Game")
    |> assign(:game, %Game{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Games")
    |> assign(:game, nil)
  end

  @impl true
  def handle_info({RacingLeaderboardsWeb.GameLive.FormComponent, {:saved, game}}, socket) do
    {:noreply, stream_insert(socket, :games, game)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game = Games.get_game!(id)
    {:ok, _} = Games.delete_game(game)

    {:noreply, stream_delete(socket, :games, game)}
  end
end
