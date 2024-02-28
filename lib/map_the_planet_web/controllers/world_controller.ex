defmodule MapThePlanetWeb.WorldController do
  use MapThePlanetWeb, :controller

  alias MapThePlanet.Maps
  alias MapThePlanet.Maps.World

  def index(conn, _params) do
    worlds = Maps.list_worlds()
    render(conn, :index, worlds: worlds)
  end

  def new(conn, _params) do
    changeset = Maps.change_world(%World{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"world" => world_params}) do
    case Maps.create_world(world_params) do
      {:ok, world} ->
        conn
        |> put_flash(:info, "World created successfully.")
        |> redirect(to: ~p"/worlds/#{world}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    world = Maps.get_world!(id)
    render(conn, :show, world: world)
  end

  def edit(conn, %{"id" => id}) do
    world = Maps.get_world!(id)
    changeset = Maps.change_world(world)
    render(conn, :edit, world: world, changeset: changeset)
  end

  def update(conn, %{"id" => id, "world" => world_params}) do
    world = Maps.get_world!(id)

    case Maps.update_world(world, world_params) do
      {:ok, world} ->
        conn
        |> put_flash(:info, "World updated successfully.")
        |> redirect(to: ~p"/worlds/#{world}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, world: world, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    world = Maps.get_world!(id)
    {:ok, _world} = Maps.delete_world(world)

    conn
    |> put_flash(:info, "World deleted successfully.")
    |> redirect(to: ~p"/worlds")
  end
end
