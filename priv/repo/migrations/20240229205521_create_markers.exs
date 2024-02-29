defmodule MapThePlanet.Repo.Migrations.CreateMarkers do
  use Ecto.Migration

  def change do
    create table(:markers) do
      add :latlng, {:array, :float}
      add :world_id, references(:worlds, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:markers, [:world_id])
  end
end
