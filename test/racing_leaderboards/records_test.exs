defmodule RacingLeaderboards.RecordsTest do
  use RacingLeaderboards.DataCase

  alias RacingLeaderboards.Records

  describe "records" do
    alias RacingLeaderboards.Records.Record

    import RacingLeaderboards.RecordsFixtures

    @invalid_attrs %{date: nil, time: nil, user: nil, is_verified: nil}

    test "list_records/0 returns all records" do
      record = record_fixture()
      assert Records.list_records() == [record]
    end

    test "get_record!/1 returns the record with given id" do
      record = record_fixture()
      assert Records.get_record!(record.id) == record
    end

    test "create_record/1 with valid data creates a record" do
      valid_attrs = %{
        date: ~D[2024-11-07],
        time: "some time",
        user: "some user",
        is_verified: true
      }

      assert {:ok, %Record{} = record} = Records.create_record(valid_attrs)
      assert record.date == ~D[2024-11-07]
      assert record.time == "some time"
      assert record.user == "some user"
      assert record.is_verified == true
    end

    test "create_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Records.create_record(@invalid_attrs)
    end

    test "update_record/2 with valid data updates the record" do
      record = record_fixture()

      update_attrs = %{
        date: ~D[2024-11-08],
        time: "some updated time",
        user: "some updated user",
        is_verified: false
      }

      assert {:ok, %Record{} = record} = Records.update_record(record, update_attrs)
      assert record.date == ~D[2024-11-08]
      assert record.time == "some updated time"
      assert record.user == "some updated user"
      assert record.is_verified == false
    end

    test "update_record/2 with invalid data returns error changeset" do
      record = record_fixture()
      assert {:error, %Ecto.Changeset{}} = Records.update_record(record, @invalid_attrs)
      assert record == Records.get_record!(record.id)
    end

    test "delete_record/1 deletes the record" do
      record = record_fixture()
      assert {:ok, %Record{}} = Records.delete_record(record)
      assert_raise Ecto.NoResultsError, fn -> Records.get_record!(record.id) end
    end

    test "change_record/1 returns a record changeset" do
      record = record_fixture()
      assert %Ecto.Changeset{} = Records.change_record(record)
    end

    test "get_fastest_records_by_game_week_combinations/2 returns fastest records grouped by circuit and car" do
      # This test would need proper setup with games, circuits, cars, and users
      # For now, we'll create a simple test structure
      # In a real scenario, you'd need to set up the full fixture chain
      
      # Create test data
      game = RacingLeaderboards.GamesFixtures.game_fixture()
      circuit = RacingLeaderboards.CircuitsFixtures.circuit_fixture(%{game_id: game.id})
      car = RacingLeaderboards.CarsFixtures.car_fixture(%{game_id: game.id})
      user1 = RacingLeaderboards.UsersFixtures.user_fixture()
      user2 = RacingLeaderboards.UsersFixtures.user_fixture(%{name: "User 2"})
      
      date = ~D[2024-11-07]
      
      # Create fast record
      fast_record = record_fixture(%{
        game_id: game.id,
        circuit_id: circuit.id,
        car_id: car.id,
        user_id: user1.id,
        date: date,
        time: ~T[01:30:00],
        is_dnf: false
      })
      
      # Create slower record
      slow_record = record_fixture(%{
        game_id: game.id,
        circuit_id: circuit.id,
        car_id: car.id,
        user_id: user2.id,
        date: date,
        time: ~T[01:45:00],
        is_dnf: false
      })
      
      combinations = Records.get_fastest_records_by_game_week_combinations(game.id, Date.to_string(date))
      
      assert length(combinations) == 1
      {circuit_result, car_result, fastest_record, all_records} = hd(combinations)
      
      assert circuit_result.id == circuit.id
      assert car_result.id == car.id
      assert fastest_record.id == fast_record.id
      assert length(all_records) == 2
    end

    test "get_fastest_records_by_game_week_combinations/2 handles only DNF records" do
      game = RacingLeaderboards.GamesFixtures.game_fixture()
      circuit = RacingLeaderboards.CircuitsFixtures.circuit_fixture(%{game_id: game.id})
      car = RacingLeaderboards.CarsFixtures.car_fixture(%{game_id: game.id})
      user = RacingLeaderboards.UsersFixtures.user_fixture()
      
      date = ~D[2024-11-07]
      
      # Create only DNF records
      dnf_record = record_fixture(%{
        game_id: game.id,
        circuit_id: circuit.id,
        car_id: car.id,
        user_id: user.id,
        date: date,
        time: ~T[01:30:00],
        is_dnf: true
      })
      
      combinations = Records.get_fastest_records_by_game_week_combinations(game.id, Date.to_string(date))
      
      assert length(combinations) == 1
      {_circuit, _car, fastest_record, all_records} = hd(combinations)
      
      assert fastest_record == nil
      assert length(all_records) == 1
    end

    test "get_fastest_records_by_game_week_combinations/2 returns empty list when no records" do
      game = RacingLeaderboards.GamesFixtures.game_fixture()
      date = ~D[2024-11-07]
      
      combinations = Records.get_fastest_records_by_game_week_combinations(game.id, Date.to_string(date))
      
      assert combinations == []
    end
  end
end
