defmodule Walkabout.ConnectionSupervisor do
  alias Walkabout.Connection

  def child_spec(args) do
    %{
      id:    __MODULE__,
      start: {__MODULE__, :start_link, args},
      type:  :supervisor
    }
  end

  def start_link do
    Supervisor.start_link(
      [connection_spec()],
      strategy: :simple_one_for_one,
      name:     __MODULE__
    )
  end

  defp connection_spec do
    Supervisor.child_spec(
      Connection,
      restart: :temporary,
      start:   {Connection, :start_link, [ ]}
    )
  end
end
