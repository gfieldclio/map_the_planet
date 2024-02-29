defmodule MapThePlanet.Repo.Migrations.AddUserIdIndexToWorlds do
  use Ecto.Migration

  def change do
    create index(:worlds, [:user_id])
  end
end
