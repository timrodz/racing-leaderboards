defmodule RacingLeaderboardsWeb.ExtendedCoreComponents do
  use Phoenix.Component

  import RacingLeaderboardsWeb.CoreComponents

  alias RacingLeaderboards.DateUtils

  use Gettext, backend: RacingLeaderboardsWeb.Gettext

  attr(:records, :list, required: true)
  attr(:request_path, :string, required: true)
  attr(:date, :string, required: true)

  attr(:circuit_id, :string, required: true)
  attr(:circuit_country, :string, required: true)
  attr(:circuit_region, :string, required: true)
  attr(:circuit_name, :string, required: true)

  attr(:game_code, :string, required: true)

  attr(:car_id, :string, required: true)
  attr(:car_name, :string, required: true)
  attr(:car_class, :string, required: true)

  attr :record_click, :any, required: true, doc: "the function for handling phx-click on each row"
  attr :add_new_record_link, :string, required: true

  def grouped_records(assigns) do
    ~H"""
    <.list>
      <:item title="Date">
        <%= @date %>
      </:item>
      <:item title="Circuit">
        <%= if @circuit_country do %>
          <%= RacingLeaderboardsWeb.Utils.Circuits.country_to_emoji(@circuit_country) %> <%= @circuit_country %>
        <% else %>
          <%= @circuit_region %>
        <% end %>
        / <%= @circuit_name %>
      </:item>
      <:item title="Car">
        <%= @car_name %> (<%= @car_class %>)
      </:item>
    </.list>
    <.table id="records" rows={@records |> Enum.with_index()} row_click={@record_click}>
      <:col :let={{_record, index}} label="#"><%= index + 1 %></:col>
      <:col :let={{record, index}} label="User">
        <span>
          <%= if index == 0, do: "🏆" %>
          <%= record.user.name %>
        </span>
      </:col>
      <:col :let={{record, _index}} label="Time">
        <%= record.time %> <%= if record.is_dnf, do: "DNF" %>
      </:col>
    </.table>
    <.link href={@add_new_record_link} class="mt-6 inline-block p-2 bg-indigo-600 text-white rounded">
      Add record
    </.link>
    """
  end

  @doc ~S"""
  Renders a container with generic styling.

  ## Examples

      <.item_grid id="users" items={@users} title="users">
        <:container :let={user}>
          <p>User ID: <%= user.id %></p>
        </:container>
      </.item_grid>
  """
  attr(:id, :string, required: true)
  attr(:title, :string, default: nil)
  attr(:items, :list, required: true)
  attr(:item_id, :any, default: nil, doc: "the function for generating the row id")
  attr(:item_click, :any, default: nil, doc: "the function for handling phx-click on each row")
  attr(:grid_class, :string, default: nil)
  attr(:grid_borders, :boolean, default: false)

  attr(:row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"
  )

  slot :container, required: true do
    attr(:class, :string)
  end

  def item_grid(assigns) do
    assigns =
      with %{items: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, item_id: assigns.item_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div id={"item-grid-#{@id}"} class="mt-10 mb-6">
      <%= if @title do %>
        <div class="mb-4">
          <h3 class="text-xl font-bold"><%= @title %></h3>
          <hr />
        </div>
      <% end %>
      <div
        id={@id}
        phx-update={match?(%Phoenix.LiveView.LiveStream{}, @items) && "stream"}
        class={[
          "overflow-y-auto sm:overflow-visible grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-4",
          @grid_class
        ]}
      >
        <div
          :for={item_container <- @items}
          id={@item_id && @item_id.(item_container)}
          class={[@grid_borders && "border-[1px] rounded-md hover:bg-zinc-50"]}
        >
          <div
            :for={container <- @container}
            phx-click={@item_click && @item_click.(item_container)}
            class={["relative", @item_click && "hover:cursor-pointer", container[:class]]}
          >
            <%= render_slot(container, @row_item.(item_container)) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr(:dt, :string, required: true)
  attr(:label, :string, default: nil)
  attr(:class, :string, default: nil)

  def datetime(assigns) do
    ~H"""
    <p class="mt-2 flex items-center gap-1 text-sm">
      <CoreComponents.icon name="hero-clock" class="h-5 w-5" />
      <%= @label %>
      <span><%= @dt |> DateUtils.render_naive_datetime_full() %></span>
    </p>
    """
  end

  attr(:dt, :string, required: true)
  attr(:label, :string, default: nil)
  attr(:class, :string, default: nil)

  def date(assigns) do
    ~H"""
    <p class="mt-2 flex items-center gap-1 text-sm">
      <%= @label %>
      <span><%= @dt |> DateUtils.render_naive_datetime_date() %></span>
    </p>
    """
  end
end
