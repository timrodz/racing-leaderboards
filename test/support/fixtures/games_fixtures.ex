defmodule RacingLeaderboards.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RacingLeaderboards.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "some name",
        image_url: "some image_url",
        url: "some url"
      })
      |> RacingLeaderboards.Games.create_game()

    game
  end
end
