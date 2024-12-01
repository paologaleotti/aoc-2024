defmodule Day1 do
  def resolve_part1 do
    {:ok, content} = File.read("inputs/day1.txt")

    {left, right} =
      String.trim(content)
      |> String.split("\n")
      |> Enum.map(fn s -> String.split(s, "   ") end)
      |> Enum.map(fn [l, r] -> {String.to_integer(l), String.to_integer(r)} end)
      |> Enum.reduce({[], []}, fn {l, r}, {l_acc, r_acc} -> {l_acc ++ [l], r_acc ++ [r]} end)

    left_sorted = Enum.sort(left)
    right_sorted = Enum.sort(right)

    Enum.zip(left_sorted, right_sorted)
    |> Enum.reduce(0, fn {l, r}, acc -> acc + abs(r - l) end)
  end
end
