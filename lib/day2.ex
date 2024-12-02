defmodule Day2 do
  @spec parse_reports() :: list(list(integer()))
  defp parse_reports do
    case File.read("inputs/day2.txt") do
      {:error, reason} ->
        raise "Error reading file: #{reason}"

      {:ok, content} ->
        String.trim(content)
        |> String.split("\n")
        |> Enum.map(fn s ->
          String.split(s, " ")
          |> Enum.map(fn n -> String.to_integer(n) end)
        end)
    end
  end

  def resolve_part1 do
    parse_reports()
    |> Enum.map(fn l -> is_level_safe(l) end)
    |> Enum.filter(fn is_safe -> is_safe end)
    |> Enum.count()
  end

  def resolve_part2 do
    evaluated =
      parse_reports()
      |> Enum.map(fn l -> {l, is_level_safe(l)} end)

    dampened_reports =
      evaluated
      |> Enum.filter(fn {_, is_safe} -> not is_safe end)
      |> Enum.map(fn {l, _} -> is_level_safe_dampened(l) end)
      |> Enum.filter(fn is_safe -> is_safe end)
      |> Enum.count()

    safe_reports =
      evaluated
      |> Enum.filter(fn {_, is_safe} -> is_safe end)
      |> Enum.count()

    safe_reports + dampened_reports
  end

  defp is_level_safe(list) do
    is_sorted = list == Enum.sort(list) or list == Enum.sort(list, &(&1 >= &2))

    is_sorted and is_adjacent_safe(list, true)
  end

  defp is_adjacent_safe([], is_safe), do: is_safe
  defp is_adjacent_safe([_], is_safe), do: is_safe

  defp is_adjacent_safe([head | tail], is_safe) do
    dist = abs(head - hd(tail))
    ok = dist >= 1 and dist <= 3

    is_adjacent_safe(tail, is_safe and ok)
  end

  defp is_level_safe_dampened(list) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {_, i} -> is_level_safe(List.delete_at(list, i)) end)
    |> Enum.any?()
  end
end
