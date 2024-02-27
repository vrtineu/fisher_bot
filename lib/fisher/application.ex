defmodule Fisher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Fisher.Worker.start_link(arg)
      # {Fisher.Worker, arg}
      Fisher.Discord.Supervisor,
      Fisher.Game.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fisher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
