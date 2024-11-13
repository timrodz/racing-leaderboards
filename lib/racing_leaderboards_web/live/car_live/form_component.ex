defmodule RacingLeaderboardsWeb.CarLive.FormComponent do
  use RacingLeaderboardsWeb, :live_component

  alias RacingLeaderboards.Cars

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %> / <%= @game.name %>
        <:subtitle>Use this form to manage car records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="car-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:class]} type="text" label="Class" />
        <.input field={@form[:horsepower]} type="text" label="Horsepower" />
        <.input field={@form[:weight]} type="text" label="Weight" />
        <.input field={@form[:powertrain_type]} type="text" label="Powertrain type" />
        <.input field={@form[:transmision_type]} type="text" label="Transmision type" />
        <.input field={@form[:engine_type]} type="text" label="Engine type" />
        <.input field={@form[:aspiration_type]} type="text" label="Aspiration type" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Car</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{car: car} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Cars.change_car(car))
     end)}
  end

  @impl true
  def handle_event("validate", %{"car" => car_params}, socket) do
    changeset = Cars.change_car(socket.assigns.car, car_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"car" => car_params}, socket) do
    save_car(socket, socket.assigns.action, car_params)
  end

  defp save_car(socket, :edit, car_params) do
    case Cars.update_car(socket.assigns.car, car_params) do
      {:ok, car} ->
        notify_parent({:saved, car})

        {:noreply,
         socket
         |> put_flash(:info, "Car updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_car(socket, :new, car_params) do
    case Cars.create_car(car_params) do
      {:ok, car} ->
        notify_parent({:saved, car})

        {:noreply,
         socket
         |> put_flash(:info, "Car created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
