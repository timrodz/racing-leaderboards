defmodule RacingLeaderboardsWeb.RecordLiveTest do
  use RacingLeaderboardsWeb.ConnCase

  import Phoenix.LiveViewTest
  import RacingLeaderboards.RecordsFixtures

  @create_attrs %{date: "2024-11-07", time: "some time", user: "some user", is_verified: true}
  @update_attrs %{
    date: "2024-11-08",
    time: "some updated time",
    user: "some updated user",
    is_verified: false
  }
  @invalid_attrs %{date: nil, time: nil, user: nil, is_verified: false}

  defp create_record(_) do
    record = record_fixture()
    %{record: record}
  end

  describe "Index" do
    setup [:create_record]

    test "lists all records", %{conn: conn, record: record} do
      {:ok, _index_live, html} = live(conn, ~p"/games/0/records")

      assert html =~ "Listing Records"
      assert html =~ record.time
    end

    test "saves new record", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/games/0/records")

      assert index_live |> element("a", "New Record") |> render_click() =~
               "New Record"

      assert_patch(index_live, ~p"/games/0/records/new")

      assert index_live
             |> form("#record-form", record: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#record-form", record: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/games/0/records")

      html = render(index_live)
      assert html =~ "Record created successfully"
      assert html =~ "some time"
    end

    test "updates record in listing", %{conn: conn, record: record} do
      {:ok, index_live, _html} = live(conn, ~p"/games/0/records")

      assert index_live |> element("#records-#{record.id} a", "Edit") |> render_click() =~
               "Edit Record"

      assert_patch(index_live, ~p"/games/0/records/#{record}/edit")

      assert index_live
             |> form("#record-form", record: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#record-form", record: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/games/0/records")

      html = render(index_live)
      assert html =~ "Record updated successfully"
      assert html =~ "some updated time"
    end

    test "deletes record in listing", %{conn: conn, record: record} do
      {:ok, index_live, _html} = live(conn, ~p"/games/0/records")

      assert index_live |> element("#records-#{record.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#records-#{record.id}")
    end
  end

  describe "Show" do
    setup [:create_record]

    test "displays record", %{conn: conn, record: record} do
      {:ok, _show_live, html} = live(conn, ~p"/games/0/records/#{record}")

      assert html =~ "Show Record"
      assert html =~ record.time
    end

    test "updates record within modal", %{conn: conn, record: record} do
      {:ok, show_live, _html} = live(conn, ~p"/games/0/records/#{record}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Record"

      assert_patch(show_live, ~p"/games/0/records/#{record}/show/edit")

      assert show_live
             |> form("#record-form", record: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#record-form", record: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/games/0/records/#{record}")

      html = render(show_live)
      assert html =~ "Record updated successfully"
      assert html =~ "some updated time"
    end
  end
end
