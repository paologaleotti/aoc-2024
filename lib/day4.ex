defmodule Day4 do
  @type matrix() :: [[String.t()]]

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
    matrix = lines |> Enum.map(&String.graphemes(&1))

    horizontal_count =
      lines
      |> Enum.flat_map(&extract_occurrences/1)
      |> Enum.count()

    vertical_count =
      matrix
      |> transpose_matrix()
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.flat_map(&extract_occurrences/1)
      |> Enum.count()

    diagonal_right_count =
      matrix
      |> get_directional_diagonals(:right)
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.flat_map(&extract_occurrences/1)
      |> Enum.count()

    diagonal_left_count =
      matrix
      |> get_directional_diagonals(:left)
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.flat_map(&extract_occurrences/1)
      |> Enum.count()

    diagonal_right_count + vertical_count + horizontal_count + diagonal_left_count
  end

  @spec transpose_matrix(matrix) :: matrix
  defp transpose_matrix(matrix) do
    Enum.zip(matrix) |> Enum.map(&Tuple.to_list/1)
  end

  defp extract_occurrences(str), do: Regex.scan(~r/(?=(XMAS|SAMX))/, str)

  def get_directional_diagonals(matrix, :right) do
    max_rows = length(matrix) - 1

    Enum.map(0..max_rows, fn x -> get_diagonal(matrix, x, 0, :right) end) ++
      Enum.map(1..max_rows, fn y -> get_diagonal(matrix, 0, y, :right) end)
  end

  def get_directional_diagonals(matrix, :left) do
    max_rows = length(matrix) - 1

    Enum.map(0..max_rows, fn x -> get_diagonal(matrix, x, 0, :left) end) ++
      Enum.map(1..max_rows, fn y -> get_diagonal(matrix, length(matrix) - 1, y, :left) end)
  end

  def get_diagonal(matrix, x, y, :right) do
    case {x, y} do
      {_, y} when y >= length(matrix) -> []
      {x, _} when x >= length(matrix) -> []
      {x, y} -> [Enum.at(Enum.at(matrix, y), x) | get_diagonal(matrix, x + 1, y + 1, :right)]
    end
  end

  def get_diagonal(matrix, x, y, :left) do
    case {x, y} do
      {_, y} when y >= length(matrix) -> []
      {x, _} when x < 0 -> []
      {x, y} -> [Enum.at(Enum.at(matrix, y), x) | get_diagonal(matrix, x - 1, y + 1, :left)]
    end
  end
end
