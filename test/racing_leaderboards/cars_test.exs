defmodule RacingLeaderboards.CarsTest do
  use RacingLeaderboards.DataCase

  alias RacingLeaderboards.Cars

  describe "cars" do
    alias RacingLeaderboards.Cars.Car

    import RacingLeaderboards.CarsFixtures

    @invalid_attrs %{name: nil, horsepower: nil, weight: nil, powertrain_type: nil, transmision_type: nil, engine_type: nil, aspiration_type: nil}

    test "list_cars/0 returns all cars" do
      car = car_fixture()
      assert Cars.list_cars() == [car]
    end

    test "get_car!/1 returns the car with given id" do
      car = car_fixture()
      assert Cars.get_car!(car.id) == car
    end

    test "create_car/1 with valid data creates a car" do
      valid_attrs = %{name: "some name", horsepower: "some horsepower", weight: "some weight", powertrain_type: "some powertrain_type", transmision_type: "some transmision_type", engine_type: "some engine_type", aspiration_type: "some aspiration_type"}

      assert {:ok, %Car{} = car} = Cars.create_car(valid_attrs)
      assert car.name == "some name"
      assert car.horsepower == "some horsepower"
      assert car.weight == "some weight"
      assert car.powertrain_type == "some powertrain_type"
      assert car.transmision_type == "some transmision_type"
      assert car.engine_type == "some engine_type"
      assert car.aspiration_type == "some aspiration_type"
    end

    test "create_car/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cars.create_car(@invalid_attrs)
    end

    test "update_car/2 with valid data updates the car" do
      car = car_fixture()
      update_attrs = %{name: "some updated name", horsepower: "some updated horsepower", weight: "some updated weight", powertrain_type: "some updated powertrain_type", transmision_type: "some updated transmision_type", engine_type: "some updated engine_type", aspiration_type: "some updated aspiration_type"}

      assert {:ok, %Car{} = car} = Cars.update_car(car, update_attrs)
      assert car.name == "some updated name"
      assert car.horsepower == "some updated horsepower"
      assert car.weight == "some updated weight"
      assert car.powertrain_type == "some updated powertrain_type"
      assert car.transmision_type == "some updated transmision_type"
      assert car.engine_type == "some updated engine_type"
      assert car.aspiration_type == "some updated aspiration_type"
    end

    test "update_car/2 with invalid data returns error changeset" do
      car = car_fixture()
      assert {:error, %Ecto.Changeset{}} = Cars.update_car(car, @invalid_attrs)
      assert car == Cars.get_car!(car.id)
    end

    test "delete_car/1 deletes the car" do
      car = car_fixture()
      assert {:ok, %Car{}} = Cars.delete_car(car)
      assert_raise Ecto.NoResultsError, fn -> Cars.get_car!(car.id) end
    end

    test "change_car/1 returns a car changeset" do
      car = car_fixture()
      assert %Ecto.Changeset{} = Cars.change_car(car)
    end
  end

  describe "cars" do
    alias RacingLeaderboards.Cars.Car

    import RacingLeaderboards.CarsFixtures

    @invalid_attrs %{name: nil, class: nil, horsepower: nil, weight: nil, powertrain_type: nil, transmision_type: nil, engine_type: nil, aspiration_type: nil}

    test "list_cars/0 returns all cars" do
      car = car_fixture()
      assert Cars.list_cars() == [car]
    end

    test "get_car!/1 returns the car with given id" do
      car = car_fixture()
      assert Cars.get_car!(car.id) == car
    end

    test "create_car/1 with valid data creates a car" do
      valid_attrs = %{name: "some name", class: "some class", horsepower: "some horsepower", weight: "some weight", powertrain_type: "some powertrain_type", transmision_type: "some transmision_type", engine_type: "some engine_type", aspiration_type: "some aspiration_type"}

      assert {:ok, %Car{} = car} = Cars.create_car(valid_attrs)
      assert car.name == "some name"
      assert car.class == "some class"
      assert car.horsepower == "some horsepower"
      assert car.weight == "some weight"
      assert car.powertrain_type == "some powertrain_type"
      assert car.transmision_type == "some transmision_type"
      assert car.engine_type == "some engine_type"
      assert car.aspiration_type == "some aspiration_type"
    end

    test "create_car/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cars.create_car(@invalid_attrs)
    end

    test "update_car/2 with valid data updates the car" do
      car = car_fixture()
      update_attrs = %{name: "some updated name", class: "some updated class", horsepower: "some updated horsepower", weight: "some updated weight", powertrain_type: "some updated powertrain_type", transmision_type: "some updated transmision_type", engine_type: "some updated engine_type", aspiration_type: "some updated aspiration_type"}

      assert {:ok, %Car{} = car} = Cars.update_car(car, update_attrs)
      assert car.name == "some updated name"
      assert car.class == "some updated class"
      assert car.horsepower == "some updated horsepower"
      assert car.weight == "some updated weight"
      assert car.powertrain_type == "some updated powertrain_type"
      assert car.transmision_type == "some updated transmision_type"
      assert car.engine_type == "some updated engine_type"
      assert car.aspiration_type == "some updated aspiration_type"
    end

    test "update_car/2 with invalid data returns error changeset" do
      car = car_fixture()
      assert {:error, %Ecto.Changeset{}} = Cars.update_car(car, @invalid_attrs)
      assert car == Cars.get_car!(car.id)
    end

    test "delete_car/1 deletes the car" do
      car = car_fixture()
      assert {:ok, %Car{}} = Cars.delete_car(car)
      assert_raise Ecto.NoResultsError, fn -> Cars.get_car!(car.id) end
    end

    test "change_car/1 returns a car changeset" do
      car = car_fixture()
      assert %Ecto.Changeset{} = Cars.change_car(car)
    end
  end
end
