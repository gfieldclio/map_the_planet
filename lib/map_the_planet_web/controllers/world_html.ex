defmodule MapThePlanetWeb.WorldHTML do
  use MapThePlanetWeb, :html

  embed_templates "world_html/*"

  @doc """
  Renders a world form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def world_form(assigns)
end
