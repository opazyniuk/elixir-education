defmodule PrimitiveBank do
  @moduledoc false

  use GenServer

  def create_user(user_name) do
    GenServer.call(__MODULE__, {:create, user_name})
  end

  def activate_user(user_name) do
    GenServer.call(__MODULE__, {:activate, user_name})
  end

  def deactivate_user(user_name) do
    GenServer.call(__MODULE__, {:deactivate, user_name})
  end

  def balance(user_name) do
    GenServer.call(__MODULE__, {:balance, user_name})
  end

  def charge(user_name, amount) do
    GenServer.call(__MODULE__, {:charge, user_name, amount})
  end

  def withdrawal(user_name, amount) do
    GenServer.call(__MODULE__, {:withdrawal, user_name, amount})
  end

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(init_arg) do
    IO.puts("PrimitiveBank is up...")
    Process.send_after(__MODULE__, :list_users, 10_000, [])
    {:ok, init_arg}
  end

  def handle_call({:create, user_name}, _from, state) do
    case Map.get(state, user_name) do
      nil ->
        new_user = %{is_active: true, balance: 0}
        new_state = Map.put(state, user_name, new_user)
        {:reply, :user_created, new_state}
      _value ->
        {:reply, :already_exists, state}
    end
  end

  def handle_call({:balance, user_name}, _from, state) do
    case Map.get(state, user_name) do
      nil ->
        {:reply, {:error, :"doesn't_exist"}, state}
      %{is_active: false, balance: _balance} ->
        {:reply, {:error, :"doesn't_active"}, state}
      %{is_active: true, balance: balance} ->
        {:reply, {:ok, balance}, state}
    end
  end

  def handle_call({:charge, user_name, amount}, _from, state) do
    case Map.get(state, user_name) do
      nil ->
        {:reply, {:error, :"doesn't_exist"}, state}
      %{is_active: false, balance: _balance} ->
        {:reply, {:error, :"doesn't_active"}, state}
      %{is_active: true, balance: balance} ->
        new_balance = balance + amount
        new_user_data = %{is_active: true, balance: new_balance}
        new_state = Map.put(state, user_name, new_user_data)
        {:reply, {:ok, new_balance}, new_state}
    end
  end

  def handle_call({:withdrawal, user_name, amount}, _from, state) do
    case Map.get(state, user_name) do
      nil ->
        {:reply, {:error, :"doesn't_exist"}, state}
      %{is_active: false, balance: _balance} ->
        {:reply, {:error, :"doesn't_active"}, state}
      %{is_active: true, balance: balance} ->
        new_balance = balance - amount
        new_user_data = %{is_active: true, balance: new_balance}
        new_state = Map.put(state, user_name, new_user_data)
        {:reply, {:ok, new_balance}, new_state}
    end
  end

  def handle_call({:activate, user_name}, _from, state) do
    case Map.get(state, user_name) do
      nil -> {:reply, {:error, :"doesn't_exist"}, state}
      %{is_active: true} -> {:reply, {:error, :"user_already_activated"}, state}
      %{is_active: false, balance: balance} ->
        new_state = Map.put(state, user_name, %{is_active: true, balance: balance})
        {:reply, {:ok, %{is_active: true, balance: balance}}, new_state}
    end
  end

  def handle_call({:deactivate, user_name}, _from, state) do
    case Map.get(state, user_name) do
      nil -> {:reply, {:error, :"doesn't_exist"}, state}
      %{is_active: false} -> {:reply, {:error, :"user_already_deactivated"}, state}
      %{is_active: true, balance: balance} ->
        new_state = Map.put(state, user_name, %{is_active: false, balance: balance})
        {:reply, {:ok, %{is_active: false, balance: balance}}, new_state}
    end
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_info(:list_users, state) do
    IO.inspect(state, label: "accounts")
      Process.send_after(__MODULE__, :list_users, 10_000, [])
    {:noreply, state}
  end
end
