defmodule AppTest.Data.Users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string
    field :role, :string
    has_many :workingtimes, AppTest.Data.Workingtimes
    has_many :clocks, AppTest.Data.Clocks

    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:username, :email, :password, :role])
    |> validate_required([:username, :email, :password, :role])
    |> unique_constraint(:email)
  end
end
