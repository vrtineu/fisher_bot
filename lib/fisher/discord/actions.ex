defmodule Fisher.Discord.Actions do
  opt = fn type, name, desc, opts ->
    %{type: type, name: name, description: desc}
    |> Map.merge(Enum.into(opts, %{}))
  end

  @opts [
    opt.(:string, "name", "The name of the user", required: true),
    opt.(:string, "desc", "The description of the user", required: true)
  ]

  @commands [
    {"ping", "Ping the bot", []},
    {"create", "Create a user", @opts},
    {"echo", "Echo a message", @opts},
    {"fish", "Draw a fish", []}
  ]

  def commands, do: @commands
end
