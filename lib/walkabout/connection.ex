defmodule Walkabout.Connection do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def wrap(connection, socket) do
    GenServer.call(connection, {:wrap, socket})
  end

  def init(nil) do
    {:ok, nil}
  end

  def handle_call({:wrap, socket}, _from, nil) do
    IO.inspect("Wrapping...")
    :inet.setopts(socket, active: :once)
    {:reply, :ok, socket}
  end

  def handle_info(message, _socket) do
    IO.inspect(message)
  end
end
