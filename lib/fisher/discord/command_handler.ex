defmodule Fisher.Discord.CommandHandler do
  require Logger

  alias Fisher.Discord.Message
  alias Fisher.Game.{Board, Server, Session}

  def do_command(%{data: %{name: "fish"}} = interaction) do
    IO.inspect(interaction, label: "Interaction")
    # tmp user_id, should be from the interaction
    user_id = "1"
    %Session{board: board} = setup_fishing(user_id)
    {:msg, Message.board_parser(board)}
  end

  def do_command(%{data: %{name: "create", options: [%{value: value}]}}) do
    {:msg, "User #{value} created!"}
  end

  def do_command(interaction) do
    Logger.error("Unknown command: #{inspect(interaction)}")
    {:msg, "Unknown command"}
  end

  defp setup_fishing(user_id) do
    case Server.session_exists?(user_id) do
      true ->
        Server.get_session(user_id)

      _ ->
        create_new_session(user_id)
        Server.get_session(user_id)
    end
  end

  defp create_new_session(user_id) do
    case Board.new({12, 12}, elements: true) do
      {:ok, board} -> Server.start_link(user_id, board)
      {:error, reason} -> Logger.error("Error creating board: #{reason}")
    end
  end
end
