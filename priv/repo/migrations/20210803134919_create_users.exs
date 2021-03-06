defmodule PrimitiveBank.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :amount, :integer
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
