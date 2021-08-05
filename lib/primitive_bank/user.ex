defmodule PrimitiveBank.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :amount, :integer
    field :email, :string
    field :is_active, :boolean, default: true
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :amount, :is_active])
    |> validate_required([:username, :amount, :is_active])
  end
end
