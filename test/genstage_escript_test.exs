defmodule GenstageEscriptTest do
  use ExUnit.Case
  doctest GenstageEscript

  test "greets the world" do
    assert GenstageEscript.hello() == :world
  end
end
