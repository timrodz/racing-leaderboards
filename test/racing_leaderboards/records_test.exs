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
  end
end
