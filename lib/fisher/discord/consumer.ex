defmodule Fisher.Discord.Consumer do
  use Nostrum.Consumer

  alias Fisher.Game.Board
  alias Nostrum.Api

  require Logger

  opt = fn type, name, desc, opts ->
    %{type: type, name: name, description: desc}
    |> Map.merge(Enum.into(opts, %{}))
  end

  @opts [
    opt.(1, "teste 1", "teste 2", options: [opt.(3, "teste 3", "teste 4", required: true)])
  ]

  @commands [
    {"ping", "Ping the bot", []},
    {"echo", "Echo the message", @opts},
    {"fish", "Fish for a fish", []}
  ]

  def create_guild_commands(guild_id) do
    Enum.each(@commands, fn {name, description, options} ->
      Api.create_guild_application_command(guild_id, %{
        name: name,
        description: description,
        options: options
      })
    end)
  end

  def handle_event({:READY, %{guilds: guilds} = _event, _ws_state}) do
    guilds
    |> Enum.map(fn guild -> guild.id end)
    |> Enum.each(&create_guild_commands/1)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    message =
      case do_command(interaction) do
        {:msg, msg} -> msg
        _ -> ":white_check_mark:"
      end

    Api.create_interaction_response(interaction, %{type: 4, data: %{content: message}})
  end

  def handle_event(_event), do: :noop

  def do_command(%{data: %{name: "ping"}}), do: {:msg, "Pong!"}

  def do_command(%{data: %{name: "echo", options: [%{options: [%{value: value}]}]}}) do
    {:msg, value}
  end

  def do_command(%{data: %{name: "fish"}}) do
    {:msg, "#{Board.draw()}"}
  end

  def do_command(_interaction), do: :noop
end
