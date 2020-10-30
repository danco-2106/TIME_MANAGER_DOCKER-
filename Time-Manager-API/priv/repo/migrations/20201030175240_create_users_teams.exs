
defmodule AppTest.Repo.Migrations.CreateUsersTeams do
  use Ecto.Migration

  def change do
    create table(:users_teams, primary_key: false) do
      add(:teams_id, references(:teams, on_delete: :delete_all), primary_key: true)
      add(:users_id, references(:users, on_delete: :delete_all), primary_key: true)

      timestamps()
    end

    create(index(:users_teams, [:teams_id]))
    create(index(:users_teams, [:users_id]))

    create (
             unique_index(:users_teams, [:users_id, :teams_id], name: :users_id_teams_id_unique_index)
             )
  end
end
