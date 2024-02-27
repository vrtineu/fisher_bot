defmodule Fisher.Discord.Consumer do
  use Nostrum.Consumer

  alias Fisher.Discord.CommandHandler
  alias Fisher.Discord.{Actions, Message}
  alias Nostrum.Api

  require Logger

  def create_guild_commands(guild_id) do
    Enum.each(Actions.commands(), fn command ->
      Api.create_guild_application_command(guild_id, %{
        name: command.name,
        description: command.description,
        options: command.options
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
      case forward_interaction(interaction) do
        {:msg, msg} -> msg
        _ -> Message.emoji(:white_check_mark)
      end

    Api.create_interaction_response(interaction, %{type: 4, data: %{content: message}})
  end

  def handle_event(_event), do: :noop

  defp forward_interaction(event), do: CommandHandler.do_command(event)
end
