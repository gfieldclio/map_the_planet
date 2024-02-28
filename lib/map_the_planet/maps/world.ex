defmodule MapThePlanet.Maps.World do
  use Ecto.Schema
  import Ecto.Changeset

  schema "worlds" do
    field :name, :string
    field :user_id, :integer
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(world, attrs) do
    IO.inspect attrs

    world
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
