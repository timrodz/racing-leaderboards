defmodule RacingLeaderboardsWeb.ExtendedCoreComponents do
  use Phoenix.Component

  alias RacingLeaderboardsWeb.CoreComponents
  alias RacingLeaderboards.DateUtils

  attr(:grouped_records, :list, required: true)

  def grouped_records(assigns) do
    ~H"""
    <%= for {{game, date, circuit, car}, records} <- @grouped_records do %>
      <div class="space-y-1">
        <h2 class=" font-semibold"><%= date %></h2>
        <h3 class="text-xl">
          <%= RacingLeaderboardsWeb.Utils.Circuits.country_to_emoji(circuit.country) %> <%= circuit.name %>
        </h3>
        <h4 class="text-xl">🏎️ <%= car.name %></h4>
      </div>
      <div class="grid grid-cols-3 gap-2">
        <%= for c <- records do %>
          <div class="p-2 rounded bg-slate-100">
            <p><%= c.user.name %></p>
            <p class="font-mono"><%= c.time %></p>
          </div>
        <% end %>
      </div>
      <.link
        href={"/games/#{game}/records/new?date=#{date}&circuit=#{circuit.id}&car=#{car.id}"}
        class="inline-block p-2 bg-indigo-600 text-white rounded"
      >
        Add new entry
      </.link>
    <% end %>
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
