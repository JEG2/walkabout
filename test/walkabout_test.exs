defmodule WalkaboutTest do
  use ExUnit.Case
  doctest Walkabout

  test "greets the world" do
    assert Walkabout.hello() == :world
  end
end
