defmodule Fisher.Game.Board do
  @doc """
  Create a new board with the given size and optionally place elements on it.

  ## Parameters

  * `xy_size` - A tuple with the x and y size of the board.
  * `opts` - A keyword list with the following options:
    * `elements` - A boolean indicating if the board should have elements placed on it.

  ## Examples

      iex> Fisher.Game.Board.new({1, 5})
      {:ok, [:water, :water, :water, :water, :water]}

      iex> Fisher.Game.Board.new({1, 5}, elements: true)
      {:ok, [:water, :fish, :water, :fishing_rod, :water]}

      iex> Fisher.Game.Board.new({1, 5}, elements: false)
      {:ok, [:water, :water, :water, :water, :water]}

  """
  @spec new({x_size :: integer, y_size :: integer}, elements :: boolean) ::
          {:ok, list(list(atom))} | {:error, String.t()}
  def new(xy_size, opts \\ [])

  def new({x_size, y_size} = xy_size, opts) when x_size > 0 and y_size > 0 do
    board = matrix(xy_size)

    case Keyword.get(opts, :elements, false) do
      true -> {:ok, put_elements(board)}
      false -> {:ok, board}
    end
  end

  def new(_, _), do: {:error, "Invalid board size"}

  defp matrix({x_size, y_size}) do
    Enum.map(0..(x_size - 1), fn _ ->
      Enum.map(0..(y_size - 1), fn _ ->
        :water
      end)
    end)
  end

  defp put_elements(matrix) do
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
