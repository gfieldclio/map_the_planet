defmodule MapThePlanet.Maps.Marker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "markers" do
    field :coordinate, {:array, :float}
    belongs_to :world, MapThePlanet.Maps.World

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(marker, attrs) do
    marker
    |> cast(attrs, [:coordinate])
    |> validate_required([:coordinate])
  end

  def x(marker) do
    hd marker.coordinate
  end

  def y(marker) do
    marker.coordinate
    |> tl
    |> hd
  end
end
