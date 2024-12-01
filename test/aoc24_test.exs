defmodule Aoc24Test do
  use ExUnit.Case
  doctest Aoc24

  test "day 1" do
    assert Day1.resolve_part1() == 1_319_616
    assert Day1.resolve_part2() == 27_267_728
  end
end
