defmodule MapThePlanet.Repo.Migrations.AddUserIdToWorldTable do
  use Ecto.Migration

  def up do
    alter table(:worlds) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end

  def down do
    alter table(:worlds) do
      remove :user_id
    end
  end
end
