defmodule RacingLeaderboardsWeb.RecordLive.FormComponent do
  alias RacingLeaderboards.Cars
  alias RacingLeaderboards.Circuits
  use RacingLeaderboardsWeb, :live_component

  alias RacingLeaderboards.Users
  alias RacingLeaderboards.Records

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage record records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="record-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:user_id]}
          type="select"
          label="User"
          options={@users}
          value={@selected_user}
        />
        <.input
          field={@form[:circuit_id]}
          type="select"
          label="Circuit"
          options={@circuits}
          value={@selected_circuit}
        />
        <.input
          field={@form[:car_id]}
          type="select"
          label="Car"
          options={@cars}
          value={@selected_car}
        />
        <.input field={@form[:time]} type="text" label="Time (mm:ss)" placeholder="2:18.813" />
        <.input field={@form[:is_dnf]} type="checkbox" label="DNF (Did not finish)" />
        <.input field={@form[:date]} type="date" label="Date" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Record</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{record: record, game_id: game_id} = assigns, socket) do
    users =
      [
        {"Select", -1}
        | Users.list_users()
          |> Enum.map(&{&1.name, &1.id})
      ]

    circuits =
      [
        {"Select", -1}
        | Circuits.list_circuits_by_game(game_id)
          |> Enum.map(
            &{"#{if &1.country != "", do: &1.country, else: &1.region}: #{&1.name}", &1.id}
          )
      ]

    cars =
      [
        {"Select", -1}
        | Cars.list_cars_by_game(game_id)
          |> Enum.map(&{&1.name, &1.id})
      ]

    selected_user = record.user_id
    selected_circuit = record.circuit_id
    selected_car = record.car_id

    {:ok,
     socket
     |> assign(assigns)
     |> assign(
       users: users,
       circuits: circuits,
       cars: cars,
       selected_user: selected_user,
       selected_circuit: selected_circuit,
       selected_car: selected_car
     )
     |> assign_new(:form, fn ->
       to_form(Records.change_record(record))
     end)}
  end

  @impl true
  def handle_event("validate", %{"record" => record_params}, socket) do
    selected_user = record_params["user_id"]
    selected_circuit = record_params["circuit_id"]
    selected_car = record_params["car_id"]
    changeset = Records.change_record(socket.assigns.record, record_params)

    {:noreply,
     socket
     |> assign(
       selected_user: selected_user,
       selected_circuit: selected_circuit,
       selected_car: selected_car
     )
     |> assign(form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"record" => record_params}, socket) do
    save_record(socket, socket.assigns.action, record_params)
  end

  defp save_record(socket, :edit, record_params) do
    case Records.update_record(socket.assigns.record, record_params) do
      {:ok, record} ->
        notify_parent({:saved, record})

        {:noreply,
         socket
         |> put_flash(:info, "Record updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_record(socket, :new, record_params) do
    case Records.create_record(record_params) do
      {:ok, record} ->
        notify_parent({:saved, record})

        {:noreply,
         socket
         |> put_flash(:info, "Record created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
