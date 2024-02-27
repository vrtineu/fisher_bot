defmodule Fisher.Game.CommandHandler do
  require Logger

  def do_command(%{data: %{name: "ping"}}), do: {:msg, "Pong!"}

  def do_command(%{data: %{name: "echo", options: [%{options: [%{value: value}]}]}}) do
    {:msg, value}
  end

  def do_command(%{data: %{name: "fish"}}) do
    {:msg, "#{Fisher.Game.Board.draw()}"}
  end

  def do_command(%{data: %{name: "create", options: [%{value: value}]}}) do
    {:msg, "User #{value} created!"}
  end

  def do_command(interaction) do
    Logger.error("Unknown command: #{inspect(interaction)}")
    {:msg, "Unknown command"}
  end
end
