defmodule RacingLeaderboards.RecordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RacingLeaderboards.Records` context.
  """

  @doc """
  Generate a record.
  """
  def record_fixture(attrs \\ %{}) do
    {:ok, record} =
      attrs
      |> Enum.into(%{
        date: ~D[2024-11-07],
        time: "some time",
        user: "some user",
        is_verified: true
      })
      |> RacingLeaderboards.Records.create_record()

    record
  end
end
