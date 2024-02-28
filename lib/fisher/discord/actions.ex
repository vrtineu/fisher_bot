defmodule Fisher.Discord.Actions do
  @available_commands [
    :fish,
    :move_rod
  ]

  def commands() do
    Enum.map(@available_commands, &command/1)
  end

  # defp create_option(type, name, description, opts \\ []) do
  #   %{type: type, name: name, description: description}
  #   |> Map.merge(Enum.into(opts, %{}))
  # end

  defp command(:fish) do
    %{name: "fish", description: "Fish for a fish", options: []}
  end

  defp command(:move_rod) do
    %{
      name: "move",
      description: "Move the fishing rod",
      options: [
        %{
          name: "direction",
          description: "The direction to move the rod",
          type: command_type(:string),
          required: true,
          choices: [
            %{name: "up", value: "up"},
            %{name: "down", value: "down"},
            %{name: "left", value: "left"},
            %{name: "right", value: "right"}
          ]
        }
      ]
    }
  end

  defp command_type(:subcommand), do: 1
  defp command_type(:subcommand_group), do: 2
  defp command_type(:string), do: 3
  defp command_type(:integer), do: 4
  defp command_type(:boolean), do: 5
  defp command_type(:user), do: 6
  defp command_type(:channel), do: 7
  defp command_type(:role), do: 8
  defp command_type(:mentionable), do: 9
  defp command_type(:number), do: 10
  defp command_type(:attachment), do: 11
end
