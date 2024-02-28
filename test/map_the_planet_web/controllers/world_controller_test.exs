defmodule MapThePlanetWeb.WorldControllerTest do
  use MapThePlanetWeb.ConnCase

  import MapThePlanet.MapsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all worlds", %{conn: conn} do
      conn = get(conn, ~p"/worlds")
      assert html_response(conn, 200) =~ "Listing Worlds"
    end
  end

  describe "new world" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/worlds/new")
      assert html_response(conn, 200) =~ "New World"
    end
  end

  describe "create world" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/worlds", world: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/worlds/#{id}"

      conn = get(conn, ~p"/worlds/#{id}")
      assert html_response(conn, 200) =~ "World #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/worlds", world: @invalid_attrs)
      assert html_response(conn, 200) =~ "New World"
    end
  end

  describe "edit world" do
    setup [:create_world]

    test "renders form for editing chosen world", %{conn: conn, world: world} do
      conn = get(conn, ~p"/worlds/#{world}/edit")
      assert html_response(conn, 200) =~ "Edit World"
    end
  end

  describe "update world" do
    setup [:create_world]

    test "redirects when data is valid", %{conn: conn, world: world} do
      conn = put(conn, ~p"/worlds/#{world}", world: @update_attrs)
      assert redirected_to(conn) == ~p"/worlds/#{world}"

      conn = get(conn, ~p"/worlds/#{world}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, world: world} do
      conn = put(conn, ~p"/worlds/#{world}", world: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit World"
    end
  end

  describe "delete world" do
    setup [:create_world]

    test "deletes chosen world", %{conn: conn, world: world} do
      conn = delete(conn, ~p"/worlds/#{world}")
      assert redirected_to(conn) == ~p"/worlds"

      assert_error_sent 404, fn ->
        get(conn, ~p"/worlds/#{world}")
      end
    end
  end

  defp create_world(_) do
    world = world_fixture()
    %{world: world}
  end
end
