defmodule FisherTest do
  use ExUnit.Case
  doctest Fisher

  test "greets the world" do
    assert Fisher.hello() == :world
  end
end
