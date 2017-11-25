defmodule Walkabout.Connection do
  use GenServer
  require Logger

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
    :inet.setopts(socket, active: :once)
    {:reply, :ok, socket}
  end

  def handle_info({:tcp, socket, message}, socket) do
    IO.inspect(message)
    :inet.setopts(socket, active: :once)
    {:noreply, socket}
  end
  def handle_info({:tcp_closed, socket}, socket) do
    {:stop, :normal, socket}
  end
  def handle_info(message, socket) do
    Logger.debug("Unexpected message:  #{inspect message}")
    {:noreply, socket}
  end
end
