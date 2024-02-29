defmodule Fisher.Game.Server do
  use GenServer

  alias Fisher.Game

  #######################
  #     Server API      #
  #######################

  def start_link(user_id, %Game{} = session) do
    GenServer.start_link(__MODULE__, session, name: via_tuple(user_id))
  end

  def get_session(user_id) do
    GenServer.call(via_tuple(user_id), :get_session)
  end

  def session_exists?(user_id) do
    case GenServer.whereis(via_tuple(user_id)) do
      nil -> false
      _ -> true
    end
  end

  defp via_tuple(user_id) do
    {:via, Registry, {Fisher.GameRegistry, user_id}}
  end

  def update_board(user_id, new_board) do
    GenServer.call(via_tuple(user_id), {:update_board, new_board})
  end

  #######################
  #      Callbacks      #
  #######################

  @impl true
  def init(session), do: {:ok, session}

  @impl true
  def handle_call(:get_session, _from, session) do
    {:reply, session, session}
  end

  @impl true
  def handle_call({:update_board, new_board}, _from, session) do
    new_session = %{session | board: new_board}
    {:reply, new_session, new_session}
  end
end
