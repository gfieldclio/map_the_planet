defmodule MapThePlanet.Maps.Marker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "markers" do
    field :latlng, {:array, :float}
    belongs_to :world, MapThePlanet.Maps.World

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(marker, attrs) do
    marker
    |> cast(attrs, [:latlng])
    |> validate_required([:latlng])
  end

  def lat(marker) do
    hd marker.latlng
  end

  def lng(marker) do
    marker.latlng
    |> tl
    |> hd
  end
end
