defmodule Fisher.Game do
  alias Fisher.Game
  alias Fisher.Game.{Board, Server}

  require Logger

  defstruct [:user_id, :fishing, :board]

  def new(user_id, fishing, board) do
    %__MODULE__{user_id: user_id, fishing: fishing, board: board}
  end

  def get_session(user_id) do
    case Server.session_exists?(user_id) do
      true ->
        {:ok, Server.get_session(user_id)}

      _ ->
        {:error, :no_session}
    end
  end

  def get_session!(user_id) do
    case Server.session_exists?(user_id) do
      true ->
        {:ok, Server.get_session(user_id)}

      _ ->
        {:ok, create_new_game(user_id)}
    end
  end

  defp create_new_game(user_id) do
    with {:ok, board} <- Board.new({11, 11}, elements: true),
         %Game{} = game <- Game.new(user_id, true, board) do
      Server.start_link(user_id, game)

      game
    else
      {:error, reason} ->
        Logger.error("Failed to create new game: #{reason}")

      _ ->
        Logger.error("Failed to create new game")
    end
  end

  def move_rod(user_id, direction) do
    case get_session(user_id) do
      {:ok, %Game{board: board}} ->
        new_board = Board.move_rod(board, direction)
        Server.update_board(user_id, new_board)
        {:ok, new_board}

      {:error, :no_session} = error ->
        error
    end
  end
end
