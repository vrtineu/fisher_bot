defmodule Fisher.Game.CommandHandler do
  def do_command(%{data: %{name: "ping"}}), do: {:msg, "Pong!"}

  def do_command(%{data: %{name: "echo", options: [%{options: [%{value: value}]}]}}) do
    {:msg, value}
  end

  def do_command(%{data: %{name: "fish"}}) do
    {:msg, "#{Fisher.Game.Board.draw()}"}
  end

  def do_command(_interaction), do: :noop
end
