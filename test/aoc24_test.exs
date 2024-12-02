defmodule Aoc24Test do
  use ExUnit.Case
  doctest Aoc24

  test "day 1" do
    assert Day1.resolve_part1() == 1_319_616
    assert Day1.resolve_part2() == 27_267_728
  end

  test "day 2" do
    assert Day2.resolve_part1() == 463
    assert Day2.resolve_part2() == 514
  end
end
