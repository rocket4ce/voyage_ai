defmodule VoyageAiTest do
  use ExUnit.Case
  doctest VoyageAi

  test "greets the world" do
    assert VoyageAi.hello() == :world
  end
end
