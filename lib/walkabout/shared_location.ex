defmodule Walkabout.SharedLocation do
  use GenServer
  alias Walkabout.Location

  def start_link(path) do
    GenServer.start_link(__MODULE__, path, name: __MODULE__)
  end

  def join(connection) do
    
  end

  def init(path) do
    location =
      path
      |> File.read!
      |> Location.parse
    {:ok, location}
  end
end
