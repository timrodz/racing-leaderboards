defmodule RacingLeaderboardsWeb.RecordLive.Index do
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Records
  alias RacingLeaderboards.Records.Record

  @impl true
  def mount(_params, _session, socket) do
    records = Records.list_records()

    {:ok,
     socket
     |> stream(:records, records)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    today = NaiveDateTime.local_now() |> NaiveDateTime.to_date()
    game = Games.get_game_by_code!(params["game_code"])

    {:noreply,
     socket
     |> assign(
       game: game,
       date: params["date"],
       user_id: params["user"],
       circuit_id: params["circuit"],
       car_id: params["car"],
       redirect_to: params["redirect_to"]
     )
     |> apply_action(socket.assigns.live_action, params)
     |> assign_new(:form, fn ->
       to_form(%{"date" => today})
     end)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Record - #{socket.assigns.game.name}")
    |> assign(:record, Records.get_record!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Record - #{socket.assigns.game.name}")
    |> assign(:record, %Record{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Records - #{socket.assigns.game.name}")
    |> assign(:record, nil)
  end

  @impl true
  def handle_info({RacingLeaderboardsWeb.RecordLive.FormComponent, {:saved, record}}, socket) do
    {:noreply, stream_insert(socket, :records, record)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    record = Records.get_record!(id)
    {:ok, _} = Records.delete_record(record)

    {:noreply, stream_delete(socket, :records, record)}
  end

  @impl true
  def handle_event("search", %{"date" => date}, socket) do
    {:noreply,
     socket |> push_navigate(to: ~p"/games/#{socket.assigns.game.code}/records/date/#{date}")}
  end
end
