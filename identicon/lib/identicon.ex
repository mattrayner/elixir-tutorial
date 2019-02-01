defmodule Identicon do
  @moduledoc """
  A collection of functionality that allows us to generate an identicon image for a user.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_colour
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{ hex: hex }
  end

  def pick_colour(%Identicon.Image{ hex: [r,g,b | _tail] } = image) do
    %Identicon.Image{ image |  colour: {r, g, b} }
  end

  def build_grid(%Identicon.Image{ hex: hex_list } = image) do
    grid =
      hex_list
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{ image | grid: grid }
  end

  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [ second, first]
  end

  def filter_odd_squares(%Identicon.Image{ grid: grid } = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{ image | grid: grid }
  end

  def build_pixel_map(%Identicon.Image{ grid: grid } = image) do
    pixel_map = Enum.map grid, fn({ _code, index }) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = { horizontal, vertical }
      bottom_left = { horizontal + 50, vertical + 50 }

      {top_left, bottom_left}
    end

    %Identicon.Image{ image | pixel_map: pixel_map }
  end

  def draw_image(%Identicon.Image{ colour: colour, pixel_map: pixel_map }) do
    canvas = :egd.create(250, 250)
    colour = :egd.color(colour)

    Enum.each(pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(canvas, start, stop, colour)
    end)

    :egd.render(canvas)
  end

  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end
end
