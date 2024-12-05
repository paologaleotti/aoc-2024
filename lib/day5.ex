defmodule Day5 do
  @type rule() :: {String.t(), String.t()}
  @type update() :: list(String.t())

  @spec parse_input() :: {list(rule()), list(update())}
  def parse_input do
    case File.read("inputs/day5.txt") do
      {:error, reason} ->
        raise "Error reading file: #{reason}"

      {:ok, content} ->
        {rules, updates} =
          String.trim(content)
          |> String.split("\n")
          |> Enum.split_while(&(&1 != ""))

        rules =
          rules
          |> Enum.map(&String.split(&1, "|"))
          |> Enum.map(fn [x, y] -> {x, y} end)

        updates =
          updates
          |> Enum.map(&String.split(&1, ","))
          |> Enum.filter(&(&1 != [""] or &1 != [""]))

        {rules, updates}
    end
  end

  def resolve_part1 do
    {rules, updates} = parse_input()

    updates
    |> Enum.filter(&is_update_ordered?(&1, rules))
    |> Enum.map(&get_middle_element/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def resolve_part2 do
    {rules, updates} = parse_input()

    updates
    |> Enum.reject(&is_update_ordered?(&1, rules))
    |> Enum.map(&reorder_wrong_update(&1, rules))
    |> Enum.map(&get_middle_element/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  @spec is_update_ordered?(update(), list(rule())) :: boolean()
  def is_update_ordered?(update, rules) do
    Enum.all?(rules, fn {x, y} ->
      x_idx = Enum.find_index(update, &(&1 == x))
      y_idx = Enum.find_index(update, &(&1 == y))

      case {x_idx, y_idx} do
        {nil, nil} -> true
        {_, nil} -> true
        {nil, _} -> true
        {l, r} -> l < r
      end
    end)
  end

  @spec reorder_wrong_update(update(), list(rule())) :: update()
  def reorder_wrong_update(update, rules) do
    if is_update_ordered?(update, rules) do
      update
    else
      scanned_update = single_scan_reorder(update, rules, update)
      reorder_wrong_update(scanned_update, rules)
    end
  end

  @spec single_scan_reorder(update(), list(rule()), update()) :: update()
  def single_scan_reorder(update, [head | tail], acc) do
    {x, y} = head
    x_idx = Enum.find_index(update, &(&1 == x))
    y_idx = Enum.find_index(update, &(&1 == y))

    case {x_idx, y_idx} do
      {nil, nil} ->
        single_scan_reorder(update, tail, acc)

      {_, nil} ->
        single_scan_reorder(update, tail, acc)

      {nil, _} ->
        single_scan_reorder(update, tail, acc)

      {l, r} when l > r ->
        new_update = swap_elements(update, x, y)
        single_scan_reorder(new_update, tail, new_update)

      _ ->
        single_scan_reorder(update, tail, acc)
    end
  end

  def single_scan_reorder(_, [], acc) do
    acc
  end

  defp get_middle_element(list) do
    length = Enum.count(list)
    Enum.at(list, div(length, 2))
  end

  defp swap_elements(list, x, y) do
    Enum.map(list, fn el ->
      case el do
        ^x -> y
        ^y -> x
        _ -> el
      end
    end)
  end
end
