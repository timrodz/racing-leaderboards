defmodule RacingLeaderboards.CarsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RacingLeaderboards.Cars` context.
  """

  @doc """
  Generate a car.
  """
  def car_fixture(attrs \\ %{}) do
    {:ok, car} =
      attrs
      |> Enum.into(%{
        aspiration_type: "some aspiration_type",
        engine_type: "some engine_type",
        horsepower: "some horsepower",
        name: "some name",
        class: "some class",
        powertrain_type: "some powertrain_type",
        transmision_type: "some transmision_type",
        weight: "some weight"
      })
      |> RacingLeaderboards.Cars.create_car()

    car
  end
end
