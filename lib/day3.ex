defmodule Day3 do
  @spec parse_memory() :: list(String.t())
  def parse_memory do
    case File.read("inputs/day3.txt") do
      {:error, reason} ->
        raise "Error reading file: #{reason}"

      {:ok, content} ->
        # Extract all mul(x,y), do() and don't() calls
        Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/, content)
        |> Enum.map(fn [h | _] -> h end)
    end
  end

  def resolve_part1 do
    parse_memory()
    |> Enum.filter(fn s -> String.contains?(s, "mul") end)
    |> Enum.map(&extract_numbers/1)
    |> Enum.map(fn [x, y] -> x * y end)
    |> Enum.sum()
  end

  def resolve_part2 do
    parse_memory()
    |> filter_enabled_mul()
    |> Enum.map(&extract_numbers/1)
    |> Enum.map(fn [x, y] -> x * y end)
    |> Enum.sum()
  end

  defp extract_numbers(str) do
    Regex.scan(~r/\d{1,3}/, str)
    |> Enum.map(fn [h | _] -> String.to_integer(h) end)
  end

  defp filter_enabled_mul(original_list), do: filter_enabled_mul(original_list, true, [])

  defp filter_enabled_mul([], _, acc), do: acc

  defp filter_enabled_mul([head | tail], is_enabled, acc) do
    case head do
      "do()" ->
        filter_enabled_mul(tail, true, acc)

      "don't()" ->
        filter_enabled_mul(tail, false, acc)

      mul when is_enabled ->
        filter_enabled_mul(tail, is_enabled, [mul | acc])

      _other ->
        filter_enabled_mul(tail, is_enabled, acc)
    end
  end
end
