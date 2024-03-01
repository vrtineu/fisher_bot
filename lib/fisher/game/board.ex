defmodule Fisher.Game.Board do
  @moduledoc """
  The board module is responsible for creating and manipulating the game board.
  """

  @type board :: [atom()]

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
  @spec new({integer(), integer()}, Keyword.t()) :: {:ok, board()} | {:error, String.t()}
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

  def new(_, _opts), do: {:error, "Invalid board size"}

  defp size_is_valid?(x), do: x > 0 and x < 12

  defp matrix({x_size, y_size}) do
    Enum.map(0..x_size, fn _ ->
      Enum.map(0..y_size, fn _ ->
        :water
      end)
    end)
  end

  defp random_position(matrix) do
    x_max_size = length(matrix) - 1
    y_max_size = length(hd(matrix)) - 1
    {Enum.random(0..x_max_size), Enum.random(0..y_max_size)}
  end

  defp put_elements(matrix) do
    matrix
    |> place_on_matrix(random_position(matrix), :fish)
    |> place_on_matrix(random_position(matrix), :fishing_rod)
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

  @spec move_rod(board(), :down | :left | :right | :up) :: list()
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

  @spec find_player_rod(board()) :: [{integer(), integer()}]
  def find_player_rod(matrix) do
    for {row, row_index} <- Enum.with_index(matrix),
        {cell, cell_index} <- Enum.with_index(row),
        cell == :fishing_rod do
      {row_index, cell_index}
    end
  end

  @spec move_player_rod(board(), {integer(), integer()}, {integer(), integer()}) :: board()
  def move_player_rod(matrix, {x, y}, {new_x, new_y}) do
    matrix
    |> place_on_matrix({new_x, new_y}, :fishing_rod)
    |> remove_player_rod({x, y})
  end

  @spec remove_player_rod(board(), {integer(), integer()}) :: board()
  def remove_player_rod(matrix, {x, y}), do: place_on_matrix(matrix, {x, y}, :water)
end
