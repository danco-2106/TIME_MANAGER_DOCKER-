defmodule AppTestWeb.UsersView do
  use AppTestWeb, :view
  alias AppTestWeb.UsersView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UsersView, "users.json")}
  end

  def render("show.json", %{users: users}) do
    %{data: render_one(users, UsersView, "users.json")}
  end

  def render("users.json", %{users: users}) do
    IO.puts "#################################users#####################################"
    IO.inspect(users)
    IO.puts "######################################################################"
    %{
      id: users.id,
      username: users.username,
      email: users.email,
      role: users.role,
      #password: users.password
    }
  end

  def render("sign_in.json", %{users: users}) do
    %{
      id: users.id,
      username: users.username,
      email: users.email,
      role: users.role,
      #password: users.password
    }
  end

  def render("401.json", %{message: message}) do
    %{
      errors: %{
        detail: message
      }
    }
  end
end
