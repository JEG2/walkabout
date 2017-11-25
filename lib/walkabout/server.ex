defmodule Walkabout.Server do
  alias Walkabout.{Connection, ConnectionSupervisor}

  def child_spec(args) do
    %{
      id:    __MODULE__,
      start: {__MODULE__, :start_link, args},
      type:  :supervisor
    }
  end

  def start_link(port) do
    with {:ok, server} <- Task.Supervisor.start_link(name: __MODULE__) do
      Task.Supervisor.start_child(server, fn -> start_listening(port) end)
      {:ok, server}
    end
  end

  def start_listening(port) do
    with {:ok, listen_socket} <- :gen_tcp.listen( port,
                                                  [ :binary,
                                                    packet: 1,
                                                    active: false,
                                                    ip: {0, 0, 0, 0} ] ) do
      IO.inspect("Listening...")
      accept_incoming_connections(listen_socket)
    end
  end

  def accept_incoming_connections(listen_socket) do
    with {:ok, socket}     <- :gen_tcp.accept(listen_socket),
         {:ok, connection} <- Supervisor.start_child( ConnectionSupervisor,
                                                      [ ] ) do
      IO.inspect("Accepting...")
      :gen_tcp.controlling_process(socket, connection)
      Connection.wrap(connection, socket)
      accept_incoming_connections(listen_socket)
    end
  end
end
