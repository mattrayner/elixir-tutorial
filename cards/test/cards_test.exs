defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "shuffles a deck of cards" do
    expected_value_range = [
      ["Ace", "Two", "Three"],
      ["Ace", "Three", "Two"],
      ["Two", "Ace", "Three"],
      ["Two", "Three", "Ace"],
      ["Three", "Ace", "Two"],
      ["Three", "Two", "Ace"]
    ]
    shuffled_cards = Cards.shuffle(["Ace", "Two", "Three"])
    assert Enum.member?(expected_value_range, shuffled_cards) == true
  end
end
