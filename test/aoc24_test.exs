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

  test "day 3" do
    assert Day3.resolve_part1() == 170_068_701
    assert Day3.resolve_part2() == 78_683_433
  end

  test "day 4" do
    assert Day4.resolve_part1() == 2549
  end
end
