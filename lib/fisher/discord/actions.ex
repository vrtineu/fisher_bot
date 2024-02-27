defmodule Fisher.Discord.Actions do
  @available_commands [
    :create_user
  ]

  defp create_option(type, name, description, opts \\ []) do
    %{type: type, name: name, description: description}
    |> Map.merge(Enum.into(opts, %{}))
  end

  defp command(:create_user) do
    options = [
      create_option(3, "name", "The name of the user")
    ]

    %{name: "create", description: "Create a user", options: options}
  end

  def commands() do
    Enum.map(@available_commands, &command/1)
  end
end
