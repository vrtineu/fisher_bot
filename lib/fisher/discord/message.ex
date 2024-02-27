defmodule Fisher.Discord.Message do
  def board_parser(board) do
    Enum.reduce(board, "", fn row, acc ->
      Enum.reduce(row, acc, fn cell, acc ->
        acc <> emoji(cell)
      end) <>
        "\n"
    end)
  end

  def emoji(:water), do: ":sweat_drops:"
  def emoji(:fish), do: ":tropical_fish:"
  def emoji(:fishing_rod), do: ":fishing_pole_and_fish:"
  def emoji(:white_check_mark), do: ":white_check_mark:"
  def emoji(_), do: ":white_large_square:"
end
