defmodule RacingLeaderboardsWeb.CircuitLive.FormComponent do
  alias RacingLeaderboards.Games
  use RacingLeaderboardsWeb, :live_component

  alias RacingLeaderboards.Circuits

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage circuit records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="circuit-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:game_id]}
          type="select"
          label="Game"
          options={@games}
          value={@games |> Enum.at(0) |> elem(1)}
        />
        <.input field={@form[:country]} type="text" label="Country" />
        <.input field={@form[:region]} type="text" label="Region" />
        <.input field={@form[:name]} type="text" label="Stage / Circuit name" />
        <.input field={@form[:distance]} type="number" label="Distance (Km)" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Circuit</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{circuit: circuit} = assigns, socket) do
    games =
      Games.list_games() |> Enum.map(fn g -> {g.name, g.id} end)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(games: games)
     |> assign_new(:form, fn ->
       to_form(Circuits.change_circuit(circuit))
     end)}
  end

  @impl true
  def handle_event("validate", %{"circuit" => circuit_params}, socket) do
    changeset = Circuits.change_circuit(socket.assigns.circuit, circuit_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"circuit" => circuit_params}, socket) do
    save_map(socket, socket.assigns.action, circuit_params)
  end

  defp save_map(socket, :edit, circuit_params) do
    case Circuits.update_circuit(socket.assigns.circuit, circuit_params) do
      {:ok, circuit} ->
        notify_parent({:saved, circuit})

        {:noreply,
         socket
         |> put_flash(:info, "Circuit updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_map(socket, :new, circuit_params) do
    case Circuits.create_circuit(circuit_params) do
      {:ok, circuit} ->
        notify_parent({:saved, circuit})

        {:noreply,
         socket
         |> put_flash(:info, "Circuit created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
