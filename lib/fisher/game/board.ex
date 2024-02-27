defmodule Fisher.Game.Board do
  alias Fisher.Discord.Message

  @board [
    [:water, :water, :water, :water, :water, :water, :water, :water, :water, :water],
    [:water, :water, :water, :water, :water, :water, :water, :water, :water, :water],
    [:water, :water, :water, :water, :water, :water, :water, :water, :water, :water],
    [:water, :water, :water, :water, :water, :water, :water, :water, :water, :water],
    [:water, :water, :water, :water, :water, :water, :water, :water, :water, :water],
    [:water, :water, :water, :water, :water, :water, :water, :water, :water, :water],
    [:water, :water, :water, :water, :water, :water, :water, :water, :water, :water],
    [:water, :water, :water, :water, :water, :water, :water, :water, :water, :water],
    [:water, :water, :water, :water, :water, :water, :water, :water, :water, :water],
    [:water, :water, :water, :water, :water, :water, :water, :water, :water, :water]
  ]

  def draw(), do: board()

  defp board() do
    @board
    |> place_fish(random_position())
    |> mount_string()
  end

  defp mount_string(board) do
    Enum.reduce(board, "", fn row, acc ->
      Enum.reduce(row, acc, fn cell, acc ->
        acc <> Message.emoji(cell)
      end) <>
        "\n"
    end)
  end

  defp random_position() do
    {Enum.random(0..4), Enum.random(0..4)}
  end

  defp place_fish(board, {x, y}) do
    Enum.with_index(board, fn row, row_index ->
      Enum.with_index(row, fn cell, cell_index ->
        if row_index == x and cell_index == y do
          :fish
        else
          cell
        end
      end)
    end)
  end
end
