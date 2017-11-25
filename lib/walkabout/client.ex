defmodule Walkabout.Client do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(%{host: host, port: port}) do
    {:ok, socket} =
      :gen_tcp.connect(
        String.to_charlist(host),
        port,
        [:binary, {:packet, 1}, {:active, :once}]
      )

    {:ok, %{socket: socket}}
  end

  def send(message) do
    GenServer.call(__MODULE__, {:send, message})
  end

  def disconnect do
    GenServer.stop(__MODULE__)
  end


  def handle_call({:send, message}, _, state) do
    response = :gen_tcp.send(state.socket, message)

    {:reply, response, state}
  end

  def handle_info({:tcp, _socket, msg}, state) do
    :inet.setopts(state.socket, [{:active, :once}])
    IO.puts("tcp msg recieved: #{inspect(msg)}")
    {:noreply, state}
  end
  def handle_info(message, state) do
    IO.puts("unknown message: #{inspect(message)}")
    {:noreply, state}
  end
end
