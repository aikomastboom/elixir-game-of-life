defmodule GameOfLife.Simulate do
  @moduledoc """
  Functions related to simulation and progression of the game state
  """

  @doc """
  Takes a world state and outputs the next state.

  ## Examples

      iex> GameOfLife.Simulate.simulate([[1,1],[0,1]])
      [[1,1],[1,1]]

      iex> GameOfLife.Simulate.simulate([[1,0,1],[0,1,0],[1,1,1]])
      [[0,1,0],[0,0,0],[1,1,1]]
  """
  def simulate(world) do
    boundaries = 0..(Enum.count(world) - 1)

    for x <- boundaries do
      for y <- boundaries do
        if does_cell_live?(x, y, world) do
          1
        else
          0
        end
      end
    end
  end

  def does_cell_live?(cell_x, cell_y, world) do
    friends = living_neighbors(cell_x, cell_y, world)

    if is_cell_alive?(cell_x, cell_y, world) do
      friends == 2 or friends == 3
    else
      friends == 3
    end
  end

  def living_neighbors(cell_x, cell_y, world) do
    neighbor_map = [
      is_north_alive?(cell_x, cell_y, world),
      is_northeast_alive?(cell_x, cell_y, world),
      is_northwest_alive?(cell_x, cell_y, world),
      is_south_alive?(cell_x, cell_y, world),
      is_southeast_alive?(cell_x, cell_y, world),
      is_southwest_alive?(cell_x, cell_y, world),
      is_east_alive?(cell_x, cell_y, world),
      is_west_alive?(cell_x, cell_y, world)
    ]

    Enum.filter(neighbor_map, fn x -> x end) |> Enum.count()
  end

  def is_north_alive?(cell_x, cell_y, world) do
    is_cell_alive?(cell_x, cell_y - 1, world)
  end

  def is_northeast_alive?(cell_x, cell_y, world) do
    is_cell_alive?(cell_x + 1, cell_y - 1, world)
  end

  def is_northwest_alive?(cell_x, cell_y, world) do
    is_cell_alive?(cell_x - 1, cell_y - 1, world)
  end

  def is_southeast_alive?(cell_x, cell_y, world) do
    is_cell_alive?(cell_x + 1, cell_y + 1, world)
  end

  def is_southwest_alive?(cell_x, cell_y, world) do
    is_cell_alive?(cell_x - 1, cell_y + 1, world)
  end

  def is_south_alive?(cell_x, cell_y, world) do
    is_cell_alive?(cell_x, cell_y + 1, world)
  end

  def is_east_alive?(cell_x, cell_y, world) do
    is_cell_alive?(cell_x + 1, cell_y, world)
  end

  def is_west_alive?(cell_x, cell_y, world) do
    is_cell_alive?(cell_x - 1, cell_y, world)
  end

  @doc "returns 1 for alive 0 for dead at x,y, wrapping around 1 past world borders"
  def is_cell_alive?(cell_x, cell_y, world, count \\ nil)

  def is_cell_alive?(cell_x, cell_y, world, count) when cell_x < 0 do
    count = count || Enum.count(world) - 1
    is_cell_alive?(count, cell_y, world, count)
  end

  def is_cell_alive?(cell_x, cell_y, world, count) do
    count = count || Enum.count(world) - 1

    x =
      if cell_x > count do
        0
      else
        cell_x
      end

    cell_row = Enum.at(world, x)

    is_cell_y_alive?(cell_row, cell_y, count, [cell_x, x])
  end

  def is_cell_y_alive?(cell_row, cell_y, count, cell_x) when cell_y < 0 do
    is_cell_y_alive?(cell_row, count, count, cell_x)
  end

  def is_cell_y_alive?(cell_row, cell_y, count, _cell_x) do
    y =
      if cell_y > count do
        0
      else
        cell_y
      end

    Enum.at(cell_row, y) == 1
  end

  @doc "returns 1 for alive 0 for dead at x,y, past world borders are all dead"
  def is_cell_alive_dead_borders?(cell_x, cell_y, world) when cell_x >= 0 and cell_y >= 0 do
    cell_row = Enum.at(world, cell_x)

    if cell_row != nil do
      Enum.at(cell_row, cell_y) == 1
    else
      false
    end
  end

  def is_cell_alive_dead_borders?(cell_x, cell_y, _world) when cell_x < 0 or cell_y < 0 do
    false
  end
end
