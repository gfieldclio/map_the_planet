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
    validate!(world_params)
    {:ok, tmp_file_dir_path, tmp_file_path} = create_tmp_file(world_params["map"])
    {:ok, tmp_tile_dir_path, details} = create_tmp_tiles(tmp_file_path)

    {:ok, world} = MapThePlanet.Repo.transaction(fn ->
      attributes = Map.put(world_params, "max_zoom", details.max_zoom)
      {:ok, world} = Maps.create_world_for_user(conn.assigns.current_user, attributes)
      delete_files(tmp_file_dir_path)
      File.rename!(tmp_tile_dir_path, World.asset_path(world))
      world
    end)

    conn
    |> put_flash(:info, "World created successfully.")
    |> redirect(to: ~p"/worlds/#{world}")
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

    validate!(world_params)
    {:ok, tmp_file_dir_path, tmp_file_path} = create_tmp_file(world_params["map"])
    {:ok, tmp_tile_dir_path, details} = create_tmp_tiles(tmp_file_path)

    MapThePlanet.Repo.transaction(fn ->
      attributes = Map.put(world_params, "max_zoom", details.max_zoom)
      {:ok, %World{}} = Maps.update_world(world, attributes)
      delete_files(tmp_file_dir_path)
      delete_files(World.asset_path(world))
      :ok = File.rename(tmp_tile_dir_path, World.asset_path(world))
    end)

    conn
    |> put_flash(:info, "World updated successfully.")
    |> redirect(to: ~p"/worlds/#{world}")
  end

  def delete(conn, %{"id" => id}) do
    world = Maps.get_world!(id)
    {:ok, _world} = Maps.delete_world(world)
    delete_files(World.asset_path(world))
    conn
    |> put_flash(:info, "World deleted successfully.")
    |> redirect(to: ~p"/worlds")
  end

  defp validate!(%{"map" => upload, "name" => _}) do
    allowed_types = ~w{.png .jpg .jpeg .gif}
    extension = Path.extname(upload.filename)

    if extension not in allowed_types do
      raise "Only PNG, JPG, or GIF files can be uploaded."
    end
  end

  defp create_tmp_file(upload) do
    dir_path = "assets/tmp/#{UUID.uuid4}"
    file_path = "#{dir_path}/image.png"

    File.mkdir_p!(dir_path)
    File.cp_r!(upload.path, file_path, on_conflict: fn(_a, _b) -> true end)

    {:ok, dir_path, file_path}
  end

  defp create_tmp_tiles(tmp_file_path) do
    dir_path = "assets/tmp/#{UUID.uuid4}"
    {:ok, details} = create_tiles(tmp_file_path, dir_path)

    {:ok, dir_path, details}
  rescue
    e -> {:error, e}
  end

  defp create_tiles(source_file_path, path) do
    project_root = File.cwd!

    {result, 0} = System.cmd("#{project_root}/priv/bin/maptiles", [source_file_path, "--square",  "#{path}/tiles"])
    [_, format, max_zoom] = Regex.run(~r/Format\:\s*(\w+)\s.*Maximum Zoom\:\s*(\d+)/, result)

    {:ok, %{format: format, max_zoom: max_zoom}}
  rescue
    e -> {:error, e}
  end

  defp delete_files(path) do
    File.rm_rf!(path)
  end
end
