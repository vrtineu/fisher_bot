defmodule Fisher.Discord.Consumer do
  use Nostrum.Consumer

  alias Fisher.Discord.Actions
  alias Nosedrum.Storage.Dispatcher
  alias Nostrum.Struct.Guild.UnavailableGuild

  require Logger

  defp add_commands(command_name, module, guild_id) do
    case Dispatcher.add_command(
           command_name,
           module,
           guild_id
         ) do
      {:ok, _} -> Logger.info("For guild: #{guild_id}, added command: #{command_name}")
      {:error, reason} -> Logger.error("Error adding command: #{reason}")
    end
  end

  def handle_event({:READY, %{guilds: guilds} = _event, _ws_state}) do
    Enum.each(guilds, fn %UnavailableGuild{id: guild_id} ->
      Enum.each(Actions.commands(), fn {command_name, module} ->
        add_commands(command_name, module, guild_id)
      end)
    end)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Dispatcher.handle_interaction(interaction)
  end

  def handle_event(_event), do: :noop
end
