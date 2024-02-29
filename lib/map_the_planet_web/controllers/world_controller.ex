defmodule MapThePlanetWeb.WorldController do
  use MapThePlanetWeb, :controller
  import MapThePlanet.Maps.World, only: [asset_path: 1]

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
    case Maps.create_world_for_user(conn.assigns.current_user, world_params) do
      {:ok, world} ->
        if upload = world_params["map"] do
          save_file(upload, world)
        end
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
        if upload = world_params["map"] do
          save_file(upload, world)
        end
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
    delete_files(world)
    conn
    |> put_flash(:info, "World deleted successfully.")
    |> redirect(to: ~p"/worlds")
  end

  defp save_file(upload, world) do
    project_root = File.cwd!
    world_directory_path = asset_path(world)
    original_file_path = "#{world_directory_path}/original_image.png"

    delete_files(world)
    File.mkdir_p(world_directory_path)

    File.cp_r(upload.path, original_file_path, on_conflict: fn(_a, _b) -> true end)
    System.cmd("#{project_root}/priv/bin/maptiles", [original_file_path, "--square",  "#{world_directory_path}/tiles"])
  end

  defp delete_files(world) do
    File.rm_rf(asset_path(world))
  end
end
