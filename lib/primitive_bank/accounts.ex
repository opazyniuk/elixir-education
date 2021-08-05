defmodule PrimitiveBank.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PrimitiveBank.Repo
  require Logger
  require IEx

  alias PrimitiveBank.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_by_username(username) do
    case User.get_by_username(username) do
      %User{} = user -> {:ok, user}
      nil -> {:error, "User not found or not active."}
    end
  end


  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end




  def charge_amount({:ok, %User{amount: amount} = user}, amount_to_charge) do
    new_amount = amount - String.to_integer(amount_to_charge)

    update_user(user, %{amount: new_amount})
    |> parse_results()
  end

  def charge_amount(error, _amount_to_charge) do
    error |> parse_results()
  end

  def add_amount({:ok, %User{amount: amount} = user}, amount_to_add) do
    new_amount = amount + String.to_integer(amount_to_add)

    update_user(user, %{amount: new_amount})
    |> parse_results()
  end

  def add_amount(error, _amount_to_charge) do
    error |> parse_results()
  end

  defp parse_results({:ok, %User{amount: amount}}), do: Logger.info("New user balance is #{amount}.")
  defp parse_results({:error, reason}), do: Logger.error(reason)
end
