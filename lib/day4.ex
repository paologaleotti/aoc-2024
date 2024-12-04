defmodule Day4 do
  @spec parse_lines() :: [String.t()]
  def parse_lines do
    case File.read("inputs/day4.txt") do
      {:error, reason} ->
        raise "Error reading file: #{reason}"

      {:ok, content} ->
        String.trim(content)
        |> String.split("\n")
    end
  end

  def resolve_part1 do
    lines = parse_lines()

    horizontal_count =
      lines
      |> Enum.flat_map(&extract_occurrences/1)
      |> Enum.count()

    vertical_count =
      lines
      |> Enum.map(&String.graphemes(&1))
      |> transpose_matrix()
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.flat_map(&extract_occurrences/1)
      |> Enum.count()

    vertical_count + horizontal_count
  end

  def transpose_matrix(matrix) do
    Enum.zip(matrix) |> Enum.map(&Tuple.to_list/1)
  end

  def extract_occurrences(str), do: Regex.scan(~r/XMAS|SAMX/, str)
end
