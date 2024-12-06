defmodule Day6 do
  @type matrix :: [[char()]]
  @type heading :: :up | :down | :left | :right
  @type point :: {integer(), integer()}

  @spec parse_matrix() :: matrix()
  def parse_matrix do
    case File.read("inputs/day6.txt") do
      {:error, reason} ->
        raise reason

      {:ok, content} ->
        content
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&String.graphemes/1)
        |> Enum.filter(&(&1 != []))
    end
  end

  def resolve_part1 do
    matrix = parse_matrix()

    {start_x, start_y} =
      matrix |> find_elem("^")

    steps =
      matrix
      |> traverse_map(start_x, start_y, :up, [])
      |> Enum.uniq()

    # steps
    # |> Enum.reduce(matrix, fn {x, y}, acc ->
    #   List.update_at(acc, y, fn row ->
    #     List.replace_at(row, x, "X")
    #   end)
    # end)
    # |> Enum.map(&Enum.join/1)
    # |> Enum.join("\n")
    # |> IO.puts()

    steps |> length()
  end

  @spec traverse_map(matrix(), integer(), integer(), heading(), [point()]) :: [point()]
  def traverse_map(matrix, x, y, heading, acc) do
    point = {x, y}
    new_point = next_point(point, heading)

    case check_position(matrix, new_point) do
      :wall ->
        new_heading = turn_at_wall(heading)
        traverse_map(matrix, x, y, new_heading, [point | acc])

      :outside ->
        [point | acc]

      :empty ->
        {next_x, next_y} = new_point
        traverse_map(matrix, next_x, next_y, heading, [point | acc])
    end
  end

  defp next_point({x, y}, heading) do
    case heading do
      :up -> {x, y - 1}
      :down -> {x, y + 1}
      :left -> {x - 1, y}
      :right -> {x + 1, y}
    end
  end

  defp check_position(matrix, {x, y}) do
    case elem_at(matrix, x, y) do
      nil -> :outside
      "#" -> :wall
      _ -> :empty
    end
  end

  defp turn_at_wall(heading) do
    case heading do
      :up -> :right
      :down -> :left
      :left -> :up
      :right -> :down
    end
  end

  # todo refactor this
  defp elem_at(matrix, x, y) do
    with row when not is_nil(row) <- Enum.at(matrix, y),
         elem when not is_nil(elem) <- Enum.at(row, x) do
      elem
    else
      _ -> nil
    end
  end

  defp find_elem(matrix, elem) do
    y_idx = Enum.find_index(matrix, fn row -> Enum.member?(row, elem) end)
    x_idx = Enum.find_index(Enum.at(matrix, y_idx), &(&1 == elem))
    {x_idx, y_idx}
  end
end
