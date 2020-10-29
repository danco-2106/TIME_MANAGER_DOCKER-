defmodule AppTest.Data.Users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :role, :string
    field :password, :string, virtual: true
    field :password_hash, :string
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

  def registration_changeset(users, attrs) do
    users
    |> changeset(attrs)
    |> cast(attrs, [:username, :email, :password, :role])
    |> validate_required([:username, :email, :password, :role])
    |> unique_constraint(:email)
    |> validate_length(:password, min: 8)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes:
  %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
