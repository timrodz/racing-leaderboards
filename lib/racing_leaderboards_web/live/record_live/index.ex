defmodule RacingLeaderboardsWeb.RecordLive.Index do
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :live_view

  alias RacingLeaderboards.Records
  alias RacingLeaderboards.Records.Record

  @impl true
  def mount(_params, _session, socket) do
    records = Records.list_records()

    grouped_records =
      records
      |> Enum.group_by(&{&1.circuit.game.code, &1.date, &1.circuit, &1.car})
      |> Enum.sort_by(fn {{_game, date, _circuit, _name}, _records} -> date end, :desc)

    {:ok, socket |> assign(grouped_records: grouped_records) |> stream(:records, records)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    game = Games.get_game_by_code!(params["game_code"]) |> IO.inspect()

    {:noreply,
     socket
     |> assign(game_code: game.code, game_id: game.id)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Record")
    |> assign(:record, Records.get_record!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Record")
    |> assign(:record, %Record{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Records")
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
end
