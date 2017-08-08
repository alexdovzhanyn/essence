defmodule EssenceTest do
  use ExUnit.Case
  doctest Essence

  test "greets the world" do
    assert Essence.hello() == :world
  end
end
