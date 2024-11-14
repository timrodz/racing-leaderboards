defmodule RacingLeaderboardsWeb.CircuitLiveTest do
  use RacingLeaderboardsWeb.ConnCase

  import Phoenix.LiveViewTest
  import RacingLeaderboards.CircuitsFixtures

  @create_attrs %{country: "some country", circuit: "some circuit", distance: "120.5"}
  @update_attrs %{
    country: "some updated country",
    circuit: "some updated circuit",
    distance: "456.7"
  }
  @invalid_attrs %{country: nil, circuit: nil, distance: nil}

  defp create_circuit(_) do
    map = map_fixture()
    %{map: map}
  end

  describe "Index" do
    setup [:create_circuit]

    test "lists all circuits", %{conn: conn, map: map} do
      {:ok, _index_live, html} = live(conn, ~p"/circuits")

      assert html =~ "Circuits"
      assert html =~ map.country
    end

    test "saves new map", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/circuits")

      assert index_live |> element("a", "New Circuit") |> render_click() =~
               "New Circuit"

      assert_patch(index_live, ~p"/circuits/new")

      assert index_live
             |> form("#map-form", map: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#map-form", map: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/circuits")

      html = render(index_live)
      assert html =~ "Circuit created successfully"
      assert html =~ "some country"
    end

    test "updates map in listing", %{conn: conn, map: map} do
      {:ok, index_live, _html} = live(conn, ~p"/circuits")

      assert index_live |> element("#circuits-#{map.id} a", "Edit") |> render_click() =~
               "Edit Circuit"

      assert_patch(index_live, ~p"/circuits/#{map}/edit")

      assert index_live
             |> form("#map-form", map: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#map-form", map: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/circuits")

      html = render(index_live)
      assert html =~ "Circuit updated successfully"
      assert html =~ "some updated country"
    end

    test "deletes map in listing", %{conn: conn, map: map} do
      {:ok, index_live, _html} = live(conn, ~p"/circuits")

      assert index_live |> element("#circuits-#{map.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#circuits-#{map.id}")
    end
  end

  describe "Show" do
    setup [:create_circuit]

    test "displays map", %{conn: conn, map: map} do
      {:ok, _show_live, html} = live(conn, ~p"/circuits/#{map}")

      assert html =~ "Show Circuit"
      assert html =~ map.country
    end

    test "updates map within modal", %{conn: conn, map: map} do
      {:ok, show_live, _html} = live(conn, ~p"/circuits/#{map}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Circuit"

      assert_patch(show_live, ~p"/circuits/#{map}/show/edit")

      assert show_live
             |> form("#map-form", map: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#map-form", map: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/circuits/#{map}")

      html = render(show_live)
      assert html =~ "Circuit updated successfully"
      assert html =~ "some updated country"
    end
  end
end
