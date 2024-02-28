defmodule MapThePlanet.MapsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MapThePlanet.Maps` context.
  """

  @doc """
  Generate a world.
  """
  def world_fixture(attrs \\ %{}) do
    {:ok, world} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> MapThePlanet.Maps.create_world()

    world
  end
end
