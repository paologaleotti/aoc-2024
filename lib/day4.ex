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

  def resolve_part2 do
    matrix = parse_lines() |> Enum.map(&String.graphemes(&1))
    count_x_patterns(matrix, 0, 0, 0)
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

  @spec get_diagonal(matrix, integer(), integer(), :left | :right) :: [[String.t()]]
  defp get_diagonal(matrix, x, y, :right) do
    case {x, y} do
      {_, y} when y >= length(matrix) -> []
      {x, _} when x >= length(matrix) -> []
      {x, y} -> [Enum.at(Enum.at(matrix, y), x) | get_diagonal(matrix, x + 1, y + 1, :right)]
    end
  end

  defp get_diagonal(matrix, x, y, :left) do
    case {x, y} do
      {_, y} when y >= length(matrix) -> []
      {x, _} when x < 0 -> []
      {x, y} -> [Enum.at(Enum.at(matrix, y), x) | get_diagonal(matrix, x - 1, y + 1, :left)]
    end
  end

  @spec count_x_patterns(matrix, integer(), integer(), integer()) :: integer()
  defp count_x_patterns(matrix, x, y, acc) do
    max_x = length(Enum.at(matrix, 0)) - 1
    max_y = length(matrix) - 1

    cond do
      y > max_y ->
        acc

      x > max_x ->
        count_x_patterns(matrix, 0, y + 1, acc)

      true ->
        current = Enum.at(Enum.at(matrix, y), x)

        new_acc =
          if current == "A" and find_x_pattern(matrix, x, y, max_x, max_y),
            do: acc + 1,
            else: acc

        count_x_patterns(matrix, x + 1, y, new_acc)
    end
  end

  defp find_x_pattern(matrix, x, y, max_x, max_y) do
    positions = [
      {-1, -1},
      {-1, 1},
      {1, -1},
      {1, 1}
    ]

    values =
      positions
      |> Enum.map(fn {dy, dx} -> {y + dy, x + dx} end)
      |> Enum.map(&get_matrix_value(matrix, &1, max_x, max_y))
      |> Enum.reject(&is_nil/1)

    valid_patterns = [
      ["M", "S", "M", "S"],
      ["S", "M", "S", "M"],
      ["S", "S", "M", "M"],
      ["M", "M", "S", "S"]
    ]

    values in valid_patterns
  end

  defp get_matrix_value(matrix, {row, col}, max_x, max_y) do
    with true <- row >= 0 and row <= max_y and col >= 0 and col <= max_x do
      matrix |> Enum.at(row) |> Enum.at(col)
    else
      _ -> nil
    end
  end
end
