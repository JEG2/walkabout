defmodule Walkabout.Server do
  use Task
  alias Walkabout.{Connection, ConnectionSupervisor}

  def start_link([port]) do
    Task.start_link(fn -> start_listening(port) end)
  end

  def start_listening(port) do
    with {:ok, listen_socket} <- :gen_tcp.listen( port,
                                                  [ :binary,
                                                    packet:    1,
                                                    active:    false,
                                                    ip:        {0, 0, 0, 0},
                                                    reuseaddr: true ] ) do
      accept_incoming_connections(listen_socket)
    end
  end

  def accept_incoming_connections(listen_socket) do
    with {:ok, socket}     <- :gen_tcp.accept(listen_socket),
         {:ok, connection} <- Supervisor.start_child( ConnectionSupervisor,
                                                      [ ] ) do
      :gen_tcp.controlling_process(socket, connection)
      Connection.wrap(connection, socket)
      accept_incoming_connections(listen_socket)
    end
  end
end
