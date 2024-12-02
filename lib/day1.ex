defmodule Day1 do
  defp parse_lists do
    case File.read("inputs/day1.txt") do
      {:error, reason} ->
        raise "Error reading file: #{reason}"

      {:ok, content} ->
        String.trim(content)
        |> String.split("\n")
        |> Enum.map(fn s -> String.split(s, "   ") end)
        |> Enum.map(fn [l, r] -> {String.to_integer(l), String.to_integer(r)} end)
        |> Enum.reduce({[], []}, fn {l, r}, {l_acc, r_acc} -> {l_acc ++ [l], r_acc ++ [r]} end)
    end
  end

  def resolve_part1 do
    {left, right} = parse_lists()

    left_sorted = Enum.sort(left)
    right_sorted = Enum.sort(right)

    Enum.zip(left_sorted, right_sorted)
    |> Enum.reduce(0, fn {l, r}, acc -> acc + abs(r - l) end)
  end

  def resolve_part2 do
    {left, right} = parse_lists()

    Enum.map(left, fn elem -> elem * find_duplicates_number(elem, right) end)
    |> Enum.sum()
  end

  defp find_duplicates_number(elem, list) do
    Enum.filter(list, fn x -> x == elem end)
    |> Enum.count()
  end
end
