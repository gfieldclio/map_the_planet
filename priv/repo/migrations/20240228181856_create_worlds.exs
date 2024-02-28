defmodule MapThePlanet.Repo.Migrations.CreateWorlds do
  use Ecto.Migration

  def change do
    create table(:worlds) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
