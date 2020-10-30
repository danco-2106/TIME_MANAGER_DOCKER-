defmodule AppTestWeb.TeamsController do
  use AppTestWeb, :controller

  alias AppTest.Data
  alias AppTest.Data.Teams
  alias AppTest.Data.UsersTeams

  action_fallback AppTestWeb.FallbackController

  def index(conn, _params) do
    teams = Data.list_teams()
    render(conn, "index.json", teams: teams)
  end

  def create(conn, %{"teams" => teams_params}) do
    with {:ok, %Teams{} = teams} <- Data.create_teams(teams_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.teams_path(conn, :show, teams))
      |> render("show.json", teams: teams)
    end
  end

  def addUsersInTeams(conn, %{"users_teams" => teams_users_params}) do
    IO.inspect(teams_users_params)
    with {:ok, %UsersTeams{} = users_teams} <- Data.add_users_teams(teams_users_params) do
      conn
      |> put_status(:created)
      |> redirect(to: Routes.teams_path(conn, :show, teams_users_params))
    end
  end

  def show(conn, %{"id" => id}) do
    teams = Data.get_teams!(id)
    render(conn, "show.json", teams: teams)
  end

  def update(conn, %{"id" => id, "teams" => teams_params}) do
    teams = Data.get_teams!(id)

    with {:ok, %Teams{} = teams} <- Data.update_teams(teams, teams_params) do
      render(conn, "show.json", teams: teams)
    end
  end

  def delete(conn, %{"id" => id}) do
    teams = Data.get_teams!(id)

    with {:ok, %Teams{}} <- Data.delete_teams(teams) do
      send_resp(conn, :no_content, "")
    end
  end
end
