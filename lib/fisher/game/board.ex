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

  defp size_is_valid?(x), do: x > 0 and x < 12

  defp matrix({x_size, y_size}) do
    Enum.map(0..x_size, fn _ ->
      Enum.map(0..y_size, fn _ ->
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

  def move_rod(matrix, :up) do
    [{x, y}] = find_player_rod(matrix)
    new_x = x - 1
    new_y = y
    move_player_rod(matrix, {x, y}, {new_x, new_y})
  end

  def move_rod(matrix, :down) do
    [{x, y}] = find_player_rod(matrix)
    new_x = x + 1
    new_y = y
    move_player_rod(matrix, {x, y}, {new_x, new_y})
  end

  def move_rod(matrix, :left) do
    [{x, y}] = find_player_rod(matrix)
    new_x = x
    new_y = y - 1
    move_player_rod(matrix, {x, y}, {new_x, new_y})
  end

  def move_rod(matrix, :right) do
    [{x, y}] = find_player_rod(matrix)
    new_x = x
    new_y = y + 1
    move_player_rod(matrix, {x, y}, {new_x, new_y})
  end

  def find_player_rod(matrix) do
    for {row, row_index} <- Enum.with_index(matrix),
        {cell, cell_index} <- Enum.with_index(row),
        cell == :fishing_rod do
      {row_index, cell_index}
    end
  end

  def move_player_rod(matrix, {x, y}, {new_x, new_y}) do
    matrix
    |> place_player_rod({new_x, new_y})
    |> remove_player_rod({x, y})
  end

  def remove_player_rod(matrix, {x, y}) do
    place_on_matrix(matrix, {x, y}, :water)
  end
end
