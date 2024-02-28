defmodule Fisher.Discord.Actions do
  @available_commands [
    {"fish", Fisher.Discord.Commands.Fish},
    {"move", Fisher.Discord.Commands.MoveRod}
  ]

  def commands, do: @available_commands
end
