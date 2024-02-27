defmodule Fisher.Game.Server do
  use GenServer

  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def start_fishing(user_id) do
    GenServer.call(__MODULE__, {:start_fishing, user_id})
  end

  def stop_fishing(user_id) do
    GenServer.call(__MODULE__, {:stop_fishing, user_id})
  end

  # Callbacks
  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call({:start_fishing, user_id}, _from, state) do
    case Map.get(state, user_id) do
      nil ->
        {:reply, :ok, Map.put(state, user_id, %{fishing: true})}

      %{fishing: true} ->
        {:reply, {:error, :already_fishing}, state}

      _ ->
        {:reply, :ok, Map.put(state, user_id, %{fishing: true})}
    end
  end

  def handle_call({:stop_fishing, user_id}, _from, state) do
    case Map.get(state, user_id) do
      nil ->
        {:reply, {:error, :not_fishing}, state}

      _ ->
        {:reply, :ok, Map.delete(state, user_id)}
    end
  end
end
