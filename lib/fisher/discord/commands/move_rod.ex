defmodule Fisher.Discord.Commands.MoveRod do
  alias Fisher.Discord.Message
  alias Fisher.Game
  alias Fisher.Game.Server

  @behaviour Nosedrum.ApplicationCommand

  @impl true
  def description, do: "Moves the rod to a new position."

  @impl true
  def type, do: :slash

  @impl true
  def command(%{
        data: %{options: [%{value: direction}]},
        member: %{user_id: user_id}
      }) do
    with true <- Server.session_exists?(user_id) do
      Server.move_rod(user_id, String.to_atom(direction))
      {:ok, %Game{board: board}} = Game.get_session(user_id)

      [content: Message.board_parser(board), ephemeral?: false]
    else
      _ ->
        [content: "You need to start a fishing session first.", ephemeral?: true]
    end
  end

  @impl true
  def options do
    [
      %{
        name: "direction",
        description: "The direction to move the rod",
        type: :string,
        required: true,
        choices: [
          %{name: "up", value: "up"},
          %{name: "down", value: "down"},
          %{name: "left", value: "left"},
          %{name: "right", value: "right"}
        ]
      }
    ]
  end
end
