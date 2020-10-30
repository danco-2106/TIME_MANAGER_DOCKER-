defmodule AppTestWeb.UsersController do
  use AppTestWeb, :controller

  alias AppTest.Data
  alias AppTest.Data.Users

  action_fallback AppTestWeb.FallbackController

  #  def index(conn, _params) do
  #    users = Data.list_users()
  #    render(conn, "index.json", users: users)
  #  end


  def index(conn, params) do
    users = Data.get_users_by_username!(params)
    render(conn, "users.json", users: users)
  end

  def create(conn, %{"users" => users_params}) do
    with {:ok, %Users{} = users} <- Data.create_users(users_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.users_path(conn, :show, users))
      |> render("users.json", users: users)
    end
  end

  def sign_up(conn, %{"users" => users_params}) do
    with {:ok, %Users{} = users} <- Data.create_users(users_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.users_path(conn, :show, users))
      |> render("users.json", users: users)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Data.authenticate_user(email, password) do
      {:ok, users} ->
      #voir https://hexdocs.pm/joken/introduction.html
#        {:ok, token_with_default_claims} = AppTest.Token.generate_and_sign()

        extra_claims = %{"id" => users.id, "role" => users.role, "c-xsrf-token" => Plug.CSRFProtection.get_csrf_token}
        token_with_default_plus_custom_claims = AppTest.Token.generate_and_sign!(extra_claims)

        IO.puts "######################HERE###############################"
        IO.inspect (token_with_default_plus_custom_claims)
        IO.puts "######################HERE###############################"

        #        {:ok, claims} = AppTest.Token.verify_and_validate(token)
#
#        # Example with a different key than the default
#        claims = AppTest.Token.verify_and_validate!(token, another_key)

        conn
        |> put_status(:ok)
        |> put_view(AppTestWeb.UsersView)
#        |> render("sign_in.json", users: users, token: Plug.CSRFProtection.get_csrf_token)
        |> render("sign_in.json", token: token_with_default_plus_custom_claims)
#        |> render("sign_in.json", users: users, token: get_csrf_token())

      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(AppTestWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end

  #  def show(conn, %{"email" => email, "username" => username}) do
  #    users = Data.get_users_by_username!(email, username)
  #    render(conn, "show.json", users: users)
  #  end

  def show(conn, %{"id" => id}) do
    users = Data.get_users!(id)
    render(conn, "users.json", users: users)
  end

  def update(conn, %{"id" => id, "users" => users_params}) do
    users = Data.get_users!(id)

    with {:ok, %Users{} = users} <- Data.update_users(users, users_params) do
      render(conn, "users.json", users: users)
    end
  end

  def delete(conn, %{"id" => id}) do
    users = Data.get_users!(id)

    with {:ok, %Users{}} <- Data.delete_users(users) do
      send_resp(conn, :no_content, "")
    end
  end
end
