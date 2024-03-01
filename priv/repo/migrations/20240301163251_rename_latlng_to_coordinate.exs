defmodule MapThePlanet.Repo.Migrations.RenameLatlngToCoordinate do
  use Ecto.Migration

  def change do
    rename table(:markers), :latlng, to: :coordinates
  end
end
