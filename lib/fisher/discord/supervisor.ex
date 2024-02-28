defmodule Fisher.Discord.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      {Fisher.Discord.Consumer, []},
      {Nosedrum.Storage.Dispatcher, name: Nosedrum.Storage.Dispatcher}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.init(children, opts)
  end
end
