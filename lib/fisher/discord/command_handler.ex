defmodule Fisher.Discord.CommandHandler do
  alias Fisher.Discord.Message
  alias Fisher.Game.{Board, Server, Session}

  require Logger

  def do_command(%{data: %{name: "fish"}, member: %{user_id: user_id}}) do
    %Session{board: board} = get_session!(user_id)
    {:msg, Message.board_parser(board)}
  end

  def do_command(%{
        data: %{name: "move", options: [%{value: direction}]},
        member: %{user_id: user_id}
      }) do
    with true <- Server.session_exists?(user_id) do
      Server.move_rod(user_id, String.to_atom(direction))
      %Session{board: board} = get_session(user_id)
      {:msg, Message.board_parser(board)}
    else
      error -> {:msg, error}
    end
  end

  def do_command(interaction) do
    Logger.error("Unknown command: #{inspect(interaction)}")
    {:msg, "Unknown command"}
  end

  defp get_session(user_id) do
    case Server.session_exists?(user_id) do
      true ->
        Server.get_session(user_id)

      _ ->
        "You're not fishing yet! Type /fish to start fishing!"
    end
  end

  defp get_session!(user_id) do
    case Server.session_exists?(user_id) do
      true ->
        Server.get_session(user_id)

      _ ->
        create_new_session(user_id)
        Server.get_session(user_id)
    end
  end

  defp create_new_session(user_id) do
    case Board.new({11, 11}, elements: true) do
      {:ok, board} -> Server.start_link(user_id, board)
      {:error, reason} -> Logger.error("Error creating board: #{reason}")
    end
  end
end
