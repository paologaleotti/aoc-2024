defmodule Day6 do
  @type matrix :: [[char()]]
  @type heading :: :up | :down | :left | :right
  @type point :: {integer(), integer()}
  @type point_hdg :: {point(), heading()}

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

    walked_path =
      matrix
      |> traverse_map(start_x, start_y, :up, [])

    case walked_path do
      {:ok, path} ->
        path
        |> Enum.map(&elem(&1, 0))
        |> Enum.uniq()
        |> Enum.count()

      {:error, reason} ->
        raise "Error while traversing map: #{reason}"
    end
  end

  def resolve_part2 do
    matrix = parse_matrix()

    {start_x, start_y} =
      matrix |> find_elem("^")

    walked_path =
      case traverse_map(matrix, start_x, start_y, :up, []) do
        {:ok, path} ->
          path
          |> Enum.map(&elem(&1, 0))
          |> Enum.uniq()
          |> Enum.reject(fn {x, y} -> x == start_x and y == start_y end)

        {:error, :loopdetect} ->
          raise "First traverse should not detect a loop"
      end

    find_obstacles_causing_loop(matrix, walked_path, start_x, start_y)
    |> Enum.uniq()
    |> Enum.count()
  end

  @spec find_obstacles_causing_loop(matrix(), [point()], integer(), integer()) :: [point()]
  def find_obstacles_causing_loop(matrix, points, start_x, start_y) do
    points
    |> Task.async_stream(fn {obs_x, obs_y} = point ->
      new_matrix = matrix |> replace_at(obs_x, obs_y, "#")

      case traverse_map(new_matrix, start_x, start_y, :up, []) do
        {:ok, _} -> nil
        {:error, :loopdetect} -> point
      end
    end)
    |> Stream.filter(&(&1 != {:ok, nil}))
    |> Enum.map(fn {:ok, point} -> point end)
  end

  @spec traverse_map(matrix(), integer(), integer(), heading(), [point_hdg()]) ::
          {:ok, [point()]} | {:error, :loopdetect}
  def traverse_map(matrix, x, y, heading, acc) do
    point = {x, y}
    new_point = next_point(point, heading)
    loop_detected = Enum.member?(acc, {point, heading})

    if loop_detected do
      {:error, :loopdetect}
    else
      case check_position(matrix, new_point) do
        :wall ->
          new_heading = turn_at_wall(heading)
          traverse_map(matrix, x, y, new_heading, [{point, heading} | acc])

        :outside ->
          {:ok, [{point, heading} | acc]}

        :empty ->
          {next_x, next_y} = new_point
          traverse_map(matrix, next_x, next_y, heading, [{point, heading} | acc])
      end
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

  defp elem_at(_, x, y) when is_nil(x) or is_nil(y), do: nil

  defp elem_at(matrix, x, y) do
    with row when not is_nil(row) <- Enum.at(matrix, y),
         true <- x >= 0 and x < length(row),
         true <- y >= 0 and y < length(matrix) do
      Enum.at(row, x)
    else
      _ -> nil
    end
  end

  defp find_elem(matrix, elem) do
    y_idx = Enum.find_index(matrix, fn row -> Enum.member?(row, elem) end)
    x_idx = Enum.find_index(Enum.at(matrix, y_idx), &(&1 == elem))
    {x_idx, y_idx}
  end

  defp replace_at(matrix, x, y, elem) do
    List.update_at(matrix, y, fn row ->
      List.update_at(row, x, fn _ -> elem end)
    end)
  end
end
