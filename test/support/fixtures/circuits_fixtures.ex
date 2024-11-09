defmodule RacingLeaderboards.CircuitsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RacingLeaderboards.Circuits` context.
  """

  @doc """
  Generate a map.
  """
  def map_fixture(attrs \\ %{}) do
    {:ok, map} =
      attrs
      |> Enum.into(%{
        circuit: "some circuit",
        country: "some country",
        distance: "120.5"
      })
      |> RacingLeaderboards.Circuits.create_circuit()

    map
  end
end
