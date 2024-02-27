defmodule Fisher.Game.Server do
  use GenServer

  alias Fisher.Game.Session

  #######################
  #     Server API      #
  #######################

  def start_link(user_id, board) do
    session = Session.new(user_id, true, board)
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

  #######################
  #      Callbacks      #
  #######################

  @impl true
  def init(session), do: {:ok, session}

  @impl true
  def handle_call(:get_session, _from, session) do
    {:reply, session, session}
  end
end
