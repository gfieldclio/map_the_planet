defmodule MapThePlanet.MapsTest do
  use MapThePlanet.DataCase

  alias MapThePlanet.Maps

  describe "worlds" do
    alias MapThePlanet.Maps.World

    import MapThePlanet.MapsFixtures

    @invalid_attrs %{name: nil}

    test "list_worlds/0 returns all worlds" do
      world = world_fixture()
      assert Maps.list_worlds() == [world]
    end

    test "get_world!/1 returns the world with given id" do
      world = world_fixture()
      assert Maps.get_world!(world.id) == world
    end

    test "create_world/1 with valid data creates a world" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %World{} = world} = Maps.create_world(valid_attrs)
      assert world.name == "some name"
    end

    test "create_world/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maps.create_world(@invalid_attrs)
    end

    test "update_world/2 with valid data updates the world" do
      world = world_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %World{} = world} = Maps.update_world(world, update_attrs)
      assert world.name == "some updated name"
    end

    test "update_world/2 with invalid data returns error changeset" do
      world = world_fixture()
      assert {:error, %Ecto.Changeset{}} = Maps.update_world(world, @invalid_attrs)
      assert world == Maps.get_world!(world.id)
    end

    test "delete_world/1 deletes the world" do
      world = world_fixture()
      assert {:ok, %World{}} = Maps.delete_world(world)
      assert_raise Ecto.NoResultsError, fn -> Maps.get_world!(world.id) end
    end

    test "change_world/1 returns a world changeset" do
      world = world_fixture()
      assert %Ecto.Changeset{} = Maps.change_world(world)
    end
  end
end
