defmodule PrimitiveBankWeb.BankOperationController do
  require IEx
  use PrimitiveBankWeb, :controller

  alias PrimitiveBank.Accounts
  alias PrimitiveBank.Accounts.User

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new_charge(conn, _params) do
    render(conn, "charge.html")
  end

  def charge(conn, %{"username" => username, "amount" => amount}) do
    Accounts.get_by_username(username)
    |> Accounts.charge_amount(amount)

    render(conn, "index.html")
  end

  def new_add(conn, params) do
    render(conn, "add.html")
  end

  def add(conn, %{"username" => username, "amount" => amount}) do
    Accounts.get_by_username(username)
    |> Accounts.add_amount(amount)

    render(conn, "index.html")
  end
end
