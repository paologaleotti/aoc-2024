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
    levels = parse_reports()

    Enum.map(levels, fn l -> is_level_safe(l) end)
    |> Enum.map(fn safe ->
      case safe do
        false -> 0
        true -> 1
      end
    end)
    |> Enum.sum()
  end

  defp is_level_safe(list) do
    is_sorted = list == Enum.sort(list) or list == Enum.sort(list, &(&1 >= &2))

    is_sorted and is_adiacent_safe(list, true)
  end

  defp is_adiacent_safe([], is_safe), do: is_safe
  defp is_adiacent_safe([_], is_safe), do: is_safe

  defp is_adiacent_safe([head | tail], is_safe) do
    dist = abs(head - hd(tail))
    ok = dist >= 1 and dist <= 3

    is_adiacent_safe(tail, is_safe and ok)
  end
end
