defmodule Fisher.Discord.Commands.Fish do
  alias Fisher.Discord.Message
  alias Fisher.Game

  require Logger

  @behaviour Nosedrum.ApplicationCommand

  @impl true
  def description, do: "Starts a fishing session."

  @impl true
  def type, do: :slash

  @impl true
  def command(%{member: %{user_id: user_id}}) do
    %Game{board: board} = Game.get_session!(user_id)

    [
      content: Message.board_parser(board),
      ephemeral?: false
    ]
  end

  @impl true
  def options, do: []
end
