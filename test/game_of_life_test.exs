defmodule GameOfLifeTest do
  use ExUnit.Case
  doctest GameOfLife

  setup do
    {:ok, _test_world} = GameOfLife.game_of_life(100)
  end
end
