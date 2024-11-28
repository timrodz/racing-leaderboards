defmodule RacingLeaderboardsWeb.ExtendedCoreComponents do
  use Phoenix.Component

  import RacingLeaderboardsWeb.CoreComponents

  # alias RacingLeaderboards.DateUtils

  use Gettext, backend: RacingLeaderboardsWeb.Gettext

  attr(:circuit_country, :string, required: true)
  attr(:circuit_region, :string, required: true)
  attr(:circuit_name, :string, required: true)

  attr(:car_name, :string, required: true)
  attr(:car_class, :string, required: true)
  attr(:car_sub_class, :string, default: nil)

  def record_by_date_overview(assigns) do
    ~H"""
    <div class="space-y-2">
      <div>
        <h3 class="font-semibold">Circuit</h3>
        <ul>
          <li>
            <p>
              <%= if @circuit_country do %>
                <%= @circuit_country %>
                <%= RacingLeaderboardsWeb.Utils.Circuits.country_to_emoji(@circuit_country) %>
              <% else %>
                <%= @circuit_region %>
              <% end %>
            </p>
          </li>
          <li>
            <p><%= @circuit_name %></p>
          </li>
        </ul>
      </div>
      <div>
        <h3 class="font-semibold">Car</h3>
        <p>
          <%= @car_name %>
          <span class="bg-slate-700 rounded px-2 py-1 text-white">
            <%= if @car_sub_class do %>
              <%= @car_class %> / <%= @car_sub_class %>
            <% else %>
              <%= @car_class %>
            <% end %>
          </span>
        </p>
      </div>
    </div>
    """
  end

  attr(:records, :list, required: true)
  attr :record_click, :any, default: nil, doc: "the function for handling phx-click on each row"
  attr :add_new_record_link, :string, required: true

  def grouped_records(assigns) do
    ~H"""
    <div class="px-2">
      <.table id="records" rows={@records |> Enum.with_index()} row_click={@record_click}>
        <:col :let={{_record, index}} label="#"><%= index + 1 %></:col>
        <:col :let={{record, index}} label="User">
          <span>
            <%= if index == 0, do: "🏆" %>
            <%= record.user.name %>
          </span>
        </:col>
        <:col :let={{record, _index}} label="Time">
          <%= RacingLeaderboardsWeb.DateUtils.parse_time(record.time) %>
          <%= if record.is_dnf do %>
            <span class="bg-red-600 rounded text-white px-1 py-0.5">DNF</span>
          <% end %>
        </:col>
        <:col :let={{record, _index}} label="Diff">
          <%= if not is_nil(record.diff_time) do %>
            <span class="text-red-600">
              +<%= RacingLeaderboardsWeb.DateUtils.parse_time(record.diff_time) %>
            </span>
          <% end %>
        </:col>
      </.table>
    </div>
    <.link href={@add_new_record_link} class="cta mt-2">
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

  # attr(:dt, :string, required: true)
  # attr(:label, :string, default: nil)
  # attr(:class, :string, default: nil)

  # def datetime(assigns) do
  #   ~H"""
  #   <p class="mt-2 flex items-center gap-1 text-sm">
  #     <CoreComponents.icon name="hero-clock" class="h-5 w-5" />
  #     <%= @label %>
  #     <span><%= @dt |> DateUtils.render_naive_datetime_full() %></span>
  #   </p>
  #   """
  # end

  # attr(:dt, :string, required: true)
  # attr(:label, :string, default: nil)
  # attr(:class, :string, default: nil)

  # def date(assigns) do
  #   ~H"""
  #   <p class="mt-2 flex items-center gap-1 text-sm">
  #     <%= @label %>
  #     <span><%= @dt |> DateUtils.render_naive_datetime_date() %></span>
  #   </p>
  #   """
  # end
end
