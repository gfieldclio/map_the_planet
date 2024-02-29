defmodule MapThePlanet.Repo.Migrations.AddZoomLevelToWorlds do
  use Ecto.Migration

  def up do
    alter table(:worlds) do
      add :max_zoom, :integer
    end
  end

  def down do
    alter table(:worlds) do
      remove :max_zoom
    end
  end
end
