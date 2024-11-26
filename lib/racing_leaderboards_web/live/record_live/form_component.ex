defmodule RacingLeaderboardsWeb.RecordLive.FormComponent do
  alias RacingLeaderboards.Cars
  alias RacingLeaderboards.Circuits
  use RacingLeaderboardsWeb, :live_component

  alias RacingLeaderboards.Users
  alias RacingLeaderboards.Records
  alias RacingLeaderboardsWeb.Utils.Circuits, as: CircuitUtils

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %> - <%= @game_name %>
      </.header>

      <.simple_form
        for={@form}
        id="record-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:date]} type="date" label="Date" value={@selected_date_id} />
        <.input
          field={@form[:circuit_id]}
          type="select"
          label="Circuit"
          options={@circuits}
          value={@selected_circuit_id}
        />
        <.input
          field={@form[:car_id]}
          type="select"
          label="Car"
          options={@cars}
          value={@selected_car_id}
        />
        <.input
          field={@form[:user_id]}
          type="select"
          label="User"
          options={@users}
          value={@selected_user_id}
        />
        <.input
          field={@form[:time]}
          type="text"
          label="Time (mm:ss) i.e. 09:35.123"
          placeholder="02:18.813"
        />
        <.input field={@form[:is_dnf]} type="checkbox" label="DNF (Did not finish)" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Record</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(
        %{
          record: record,
          game_id: game_id,
          # Optional
          date: date,
          user_id: user_id,
          circuit_id: circuit_id,
          car_id: car_id,
          redirect_to: redirect_to
        } =
          assigns,
        socket
      ) do
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
          |> Enum.map(&circuit_to_select(&1))
      ]

    cars =
      [
        {"Select", -1}
        | Cars.list_cars_by_game(game_id)
          |> Enum.map(&car_to_select(&1))
      ]

    selected_user_id =
      record.user_id ||
        case Integer.parse(user_id || "") do
          {id, _} -> id
          _ -> nil
        end

    selected_circuit_id =
      record.circuit_id ||
        case Integer.parse(circuit_id || "") do
          {id, _} -> id
          _ -> nil
        end

    selected_car_id =
      record.car_id ||
        case Integer.parse(car_id || "") do
          {id, _} -> id
          _ -> nil
        end

    selected_date_id =
      record.date ||
        case Date.from_iso8601(
               date || NaiveDateTime.local_now() |> NaiveDateTime.to_date() |> Date.to_string()
             ) do
          {:ok, d} -> d
          _ -> nil
        end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(
       users: users,
       circuits: circuits,
       cars: cars,
       selected_user_id: selected_user_id,
       selected_circuit_id: selected_circuit_id,
       selected_car_id: selected_car_id,
       selected_date_id: selected_date_id,
       redirect_to: redirect_to
     )
     |> assign_new(:form, fn ->
       to_form(
         record
         |> Map.put(:date, selected_date_id)
         |> Map.put(:circuit_id, selected_circuit_id)
         |> Map.put(:car_id, selected_car_id)
         |> Records.change_record()
       )
     end)}
  end

  @impl true
  def handle_event("validate", %{"record" => record_params}, socket) do
    # If record_params contains the value, that means the user assigned it
    # Otherwise we can grab the one from the socket
    # This is useful for scenarios where we want to create a new record
    # from a different page, with pre-selected parameters
    selected_user_id = record_params["user_id"] || socket.assigns.user_id
    selected_circuit_id = record_params["circuit_id"] || socket.assigns.circuit_id
    selected_car_id = record_params["car_id"] || socket.assigns.car_id
    selected_date_id = record_params["date"] || socket.assigns.date

    changeset =
      Records.change_record(
        socket.assigns.record,
        record_params
        |> Map.put("date", selected_date_id)
        |> Map.put("circuit_id", selected_circuit_id)
        |> Map.put("car_id", selected_car_id)
      )

    {:noreply,
     socket
     |> assign(
       selected_user_id: selected_user_id,
       selected_circuit_id: selected_circuit_id,
       selected_car_id: selected_car_id,
       selected_date_id: selected_date_id
     )
     |> assign(form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"record" => record_params}, socket) do
    save_record(
      socket,
      socket.assigns.action,
      record_params |> Map.put("game_id", socket.assigns.game_id)
    )
  end

  defp save_record(socket, :edit, record_params) do
    case Records.update_record(socket.assigns.record, record_params) do
      {:ok, record} ->
        notify_parent({:saved, record})

        redirect_to(socket, :edit)

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_record(socket, :new, record_params) do
    case Records.create_record(record_params) do
      {:ok, record} ->
        notify_parent({:saved, record})

        redirect_to(socket, :new)

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp redirect_to(socket, action) do
    IO.inspect(socket.assigns.redirect_to, label: "REDIRECT TO")

    message =
      case action do
        :new -> "Record created successfully"
        :edit -> "Record updated successfully"
      end

    case socket.assigns.redirect_to do
      nil ->
        {:noreply,
         socket
         |> put_flash(:info, message)
         |> push_patch(to: socket.assigns.patch)}

      _ ->
        {:noreply,
         socket
         |> put_flash(:info, message)
         |> push_navigate(to: socket.assigns.redirect_to, replace: true)}
    end
  end

  defp circuit_to_select(circuit) do
    {"#{if circuit.country != "", do: "#{CircuitUtils.country_to_emoji(circuit.country)} #{circuit.country}", else: "#{circuit.region}"} / #{circuit.name}",
     circuit.id}
  end

  defp car_to_select(car) do
    {"#{car.class} - #{car.sub_class} / #{car.name}", car.id}
  end
end
