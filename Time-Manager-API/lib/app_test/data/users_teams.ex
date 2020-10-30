defmodule AppTest.Data.UsersTeams do
  use Ecto.Schema
  import Ecto.Changeset

  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "users_teams" do
    belongs_to(:users, Users, primary_key: true)
    belongs_to(:teams, Teams, primary_key: true)

    timestamps()
  end

  @doc false
  def changeset(users_teams, attrs) do
    users_teams
    |> cast(attrs, [:users_id, :teams_id])
  end
end