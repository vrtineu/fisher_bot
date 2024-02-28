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

  def new({x_size, y_size} = xy_size, opts) when is_integer(x_size) and is_integer(y_size) do
    with true <- size_is_valid?(x_size),
         true <- size_is_valid?(y_size) do
      matrix = matrix(xy_size)

      case Keyword.get(opts, :elements, false) do
        true -> {:ok, put_elements(matrix)}
        false -> {:ok, matrix}
      end
    else
      false -> {:error, "Invalid board size"}
    end
  end

  def new(_, _), do: {:error, "Invalid board size"}

  defp size_is_valid?(x), do: x > 0 and x < 13

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

  defp random_position, do: {Enum.random(0..4), Enum.random(0..4)}

  defp place_fish(matrix, {x, y}) do
    place_on_matrix(matrix, {x, y}, :fish)
  end

  defp place_player_rod(matrix, {x, y}) do
    place_on_matrix(matrix, {x, y}, :fishing_rod)
  end

  defp place_on_matrix(matrix, {x, y}, element) do
    Enum.with_index(matrix, fn row, row_index ->
      Enum.with_index(row, fn cell, cell_index ->
        if row_index == x and cell_index == y do
          element
        else
          cell
        end
      end)
    end)
  end
end
