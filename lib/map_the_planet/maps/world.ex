defmodule MapThePlanet.Maps.World do
  use Ecto.Schema
  import Ecto.Changeset

  schema "worlds" do
    field :name, :string
    field :max_zoom, :integer
    belongs_to :user, MapThePlanet.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def asset_path(world) do
    "assets/maps/world-#{world.id}"
  end

  @doc false
  def changeset(world, attrs) do
    world
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
