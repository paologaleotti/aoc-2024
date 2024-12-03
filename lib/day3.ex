defmodule Day3 do
  defp parse_memory do
    case File.read("inputs/day3.txt") do
      {:error, reason} ->
        raise "Error reading file: #{reason}"

      {:ok, content} ->
        # Extract all 'mul(x,y)' calls
        Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)/, content)
        |> Enum.map(fn [h | _] -> h end)
    end
  end

  def resolve_part1 do
    parse_memory()
    |> Enum.map(fn s ->
      # Extract numbers from 'mul(x,y)' calls
      Regex.scan(~r/\d{1,3}/, s)
      |> Enum.map(fn [h | _] -> String.to_integer(h) end)
    end)
    |> Enum.map(fn [x, y] -> x * y end)
    |> Enum.sum()
  end
end
