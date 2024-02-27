defmodule Fisher.Game.Session do
  defstruct [:user_id, :fishing, :board]

  def new(user_id, fishing, board) do
    %__MODULE__{user_id: user_id, fishing: fishing, board: board}
  end
end
