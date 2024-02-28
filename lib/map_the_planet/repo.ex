defmodule MapThePlanet.Repo do
  use Ecto.Repo,
    otp_app: :map_the_planet,
    adapter: Ecto.Adapters.Postgres
end
