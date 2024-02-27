defmodule Fisher.Game.CommandHandler do
  require Logger

  alias Fisher.Game.Session
  alias Fisher.Game.Server

  def do_command(%{data: %{name: "ping"}}), do: {:msg, "Pong!"}

  def do_command(%{data: %{name: "echo", options: [%{options: [%{value: value}]}]}}) do
    {:msg, value}
  end

  def do_command(%{data: %{name: "fish"}}) do
    # tmp user_id, should be from the interaction
    user_id = "1"
    %Session{board: board} = setup_fishing(user_id)
    {:msg, board}
  end

  def do_command(%{data: %{name: "create", options: [%{value: value}]}}) do
    {:msg, "User #{value} created!"}
  end

  def do_command(interaction) do
    Logger.error("Unknown command: #{inspect(interaction)}")
    {:msg, "Unknown command"}
  end

  defp setup_fishing(user_id) do
    if Server.session_exists?(user_id) do
      Server.get_session(user_id)
    else
      Server.start_link(user_id, Fisher.Game.Board.draw())
      Server.get_session(user_id)
    end
  end
end
