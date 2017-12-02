defmodule Walkabout.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @default_port 8910

  def start(_type, _args) do
    start_server(@default_port)
  end

  def start_server(port) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Walkabout.Worker.start_link(arg)
      {Walkabout.SharedLocation, [Path.expand("priv/locations/simple.txt")]},
      {Walkabout.ConnectionSupervisor, [ ]},
      {Walkabout.Server, [port || @default_port]},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Walkabout.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_client(address, port) do
    children = [
      {Walkabout.Client, %{host: address, port: port || @default_port}}
    ]

    opts = [strategy: :one_for_one, name: Walkabout.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
