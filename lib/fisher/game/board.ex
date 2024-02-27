defmodule Fisher.Game.Board do
  @doc """
  Draw a board with the given size.

  ## Examples

      iex> Fisher.Game.Board.draw({0, 2})
      [[:water, :water, :water]]

  """
  @spec draw({x_size :: integer, y_size :: integer}) :: list
  def draw({x_size, y_size}), do: board(create_matrix(x_size, y_size))

  defp create_matrix(x_size, y_size) do
    Enum.map(0..x_size, fn _ ->
      Enum.map(0..y_size, fn _ ->
        :water
      end)
    end)
  end

  defp board(matrix) do
    matrix
    |> place_fish(random_position())
    |> place_player_rod(random_position())
  end

  defp random_position() do
    {Enum.random(0..4), Enum.random(0..4)}
  end

  defp place_fish(board, {x, y}) do
    place_on_board(board, {x, y}, :fish)
  end

  defp place_player_rod(board, {x, y}) do
    place_on_board(board, {x, y}, :fishing_rod)
  end

  defp place_on_board(board, {x, y}, element) do
    Enum.with_index(board, fn row, row_index ->
      Enum.with_index(row, fn cell, cell_index ->
        place_on_board({row_index, cell_index}, {x, y}, element, cell)
      end)
    end)
  end

  defp place_on_board({current_x, current_y}, {x, y}, element, cell) do
    case cell do
      :water when current_x == x and current_y == y ->
        element

      _ ->
        cell
    end
  end
end
