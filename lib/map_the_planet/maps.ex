defmodule MapThePlanet.Maps do
  @moduledoc """
  The Maps context.
  """

  import Ecto.Query, warn: false
  alias MapThePlanet.Repo
  alias MapThePlanet.Accounts.User
  alias MapThePlanet.Maps.World

  @doc """
  Returns the list of worlds.

  ## Examples

      iex> list_worlds()
      [%World{}, ...]

  """
  def list_worlds do
    Repo.all(World)
  end

  @doc """
  Gets a single world.

  Raises `Ecto.NoResultsError` if the World does not exist.

  ## Examples

      iex> get_world!(123)
      %World{}

      iex> get_world!(456)
      ** (Ecto.NoResultsError)

  """
  def get_world!(id), do: Repo.get!(World, id)

  @doc """
  Creates a world.

  ## Examples

      iex> create_world(%{field: value})
      {:ok, %World{}}

      iex> create_world(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_world_for_user(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:worlds)
    |> World.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a world.

  ## Examples

      iex> update_world(world, %{field: new_value})
      {:ok, %World{}}

      iex> update_world(world, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_world(%World{} = world, attrs) do
    world
    |> World.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a world.

  ## Examples

      iex> delete_world(world)
      {:ok, %World{}}

      iex> delete_world(world)
      {:error, %Ecto.Changeset{}}

  """
  def delete_world(%World{} = world) do
    Repo.delete(world)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking world changes.

  ## Examples

      iex> change_world(world)
      %Ecto.Changeset{data: %World{}}

  """
  def change_world(%World{} = world, attrs \\ %{}) do
    World.changeset(world, attrs)
  end

  def list_worlds_for_user(%User{} = user) do
    user
    |> Ecto.assoc(:worlds)
    |> order_by([w], desc: w.inserted_at)
    |> Repo.all
  end
end
