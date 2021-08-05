defmodule PrimitiveBank.Accounts.User do
  use Ecto.Schema
  alias PrimitiveBank.Repo
  import Ecto.Changeset
  import Ecto.Query

  schema "users" do
    field :amount, :integer
    field :email, :string
    field :is_active, :boolean, default: false
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :amount, :is_active])
    |> validate_required([:username, :email, :amount, :is_active])
  end

  def get_by_username(username) do
    query =
      from(
        u in __MODULE__,
        where: u.username == ^username,
        where: u.is_active == true,
        limit: 1
      )

    Repo.one(query)
  end
end
