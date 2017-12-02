defmodule Walkabout.Location do
  defstruct ~w[width height cells]a

  def parse(ascii_art) do
    parsed =
      ascii_art
      |> String.split("\n")
      |> Enum.with_index
      |> Enum.reduce(Map.new, fn {row, y}, map ->
        row
        |> String.graphemes
        |> Enum.with_index
        |> Enum.reduce(map, fn
          {" ", _x}, cells -> cells
          {cell, x}, cells -> Map.put(cells, {x, y}, cell)
        end)
      end)
    %__MODULE__{
      width:
        parsed
        |> Map.keys
        |> Enum.map(fn {x, _y} -> x end)
        |> Enum.max
        |> Kernel.+(1),
      height:
        parsed
        |> Map.keys
        |> Enum.map(fn {_x, y} -> y end)
        |> Enum.max
        |> Kernel.+(1),
      cells: parsed
    }
  end

  def to_message(%__MODULE__{cells: cells}) do
    Enum.reduce(cells, "LOC\n", fn {{x, y}, cell}, message ->
      message <> "#{x},#{y}:#{cell}\n"
    end)
  end
end
