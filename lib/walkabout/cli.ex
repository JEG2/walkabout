defmodule Walkabout.CLI do
  alias Walkabout.Application

  def main(argv) do
    argv
    |> parse_args
    |> run

    Process.sleep(:infinity)
  end

  def parse_args(args) do
    args
    |> OptionParser.parse!(switches: [connect: :string, port: :integer])
    |> elem(0)
    |> Map.new
  end

  def run(%{connect: address} = args) do
    Application.start_client(address, args[:port])
  end

  def run(args) do
    Application.start_server(args[:port])
  end
end
