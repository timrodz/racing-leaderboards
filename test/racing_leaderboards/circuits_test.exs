defmodule RacingLeaderboards.CircuitsTest do
  use RacingLeaderboards.DataCase

  alias RacingLeaderboards.Circuits

  describe "circuits" do
    alias RacingLeaderboards.Circuits.Circuit

    import RacingLeaderboards.CircuitsFixtures

    @invalid_attrs %{country: nil, circuit: nil, distance: nil}

    test "list_circuits/0 returns all circuits" do
      map = map_fixture()
      assert Circuits.list_circuits() == [map]
    end

    test "get_circuit!/1 returns the map with given id" do
      map = map_fixture()
      assert Circuits.get_circuit!(map.id) == map
    end

    test "create_circuit/1 with valid data creates a map" do
      valid_attrs = %{country: "some country", circuit: "some circuit", distance: "120.5"}

      assert {:ok, %Circuit{} = map} = Circuits.create_circuit(valid_attrs)
      assert map.country == "some country"
      assert map.circuit == "some circuit"
      assert map.distance == Decimal.new("120.5")
    end

    test "create_circuit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Circuits.create_circuit(@invalid_attrs)
    end

    test "update_circuit/2 with valid data updates the map" do
      map = map_fixture()

      update_attrs = %{
        country: "some updated country",
        circuit: "some updated circuit",
        distance: "456.7"
      }

      assert {:ok, %Circuit{} = map} = Circuits.update_circuit(map, update_attrs)
      assert map.country == "some updated country"
      assert map.circuit == "some updated circuit"
      assert map.distance == Decimal.new("456.7")
    end

    test "update_circuit/2 with invalid data returns error changeset" do
      map = map_fixture()
      assert {:error, %Ecto.Changeset{}} = Circuits.update_circuit(map, @invalid_attrs)
      assert map == Circuits.get_circuit!(map.id)
    end

    test "delete_circuit/1 deletes the map" do
      map = map_fixture()
      assert {:ok, %Circuit{}} = Circuits.delete_circuit(map)
      assert_raise Ecto.NoResultsError, fn -> Circuits.get_circuit!(map.id) end
    end

    test "change_circuit/1 returns a map changeset" do
      map = map_fixture()
      assert %Ecto.Changeset{} = Circuits.change_circuit(map)
    end
  end
end
