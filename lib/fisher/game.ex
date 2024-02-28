defmodule Fisher.Game do
  alias Fisher.Game.{Board, Server}

  require Logger

  defstruct [:user_id, :fishing, :board]

  def new(user_id, fishing, board) do
    %__MODULE__{user_id: user_id, fishing: fishing, board: board}
  end

  def get_session(user_id) do
    case Server.session_exists?(user_id) do
      true ->
        Server.get_session(user_id)

      _ ->
        "You're not fishing yet! Type /fish to start fishing!"
    end
  end

  def get_session!(user_id) do
    case Server.session_exists?(user_id) do
      true ->
        Server.get_session(user_id)

      _ ->
        create_new_session(user_id)
        Server.get_session(user_id)
    end
  end

  def create_new_session(user_id) do
    case Board.new({11, 11}, elements: true) do
      {:ok, board} -> Server.start_link(user_id, board)
      {:error, reason} -> Logger.error("Error creating board: #{reason}")
    end
  end
end
