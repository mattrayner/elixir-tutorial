defmodule Cards do
  @moduledoc """
  Documentation for Cards.
  """

  @doc """
  Created a deck of cards

  ## Examples

      iex> Cards.create_deck()
      ["Ace of Spades", "Two of Spades", "Three of Spades", "Four of Spades",
      "Five of Spades", "Six of Spades", "Seven of Spades", "Eight of Spades",
      "Nine of Spades", "Ten of Spades", "Jack of Spades", "Queen of Spades",
      "King of Spades", "Ace of Clubs", "Two of Clubs", "Three of Clubs",
      "Four of Clubs", "Five of Clubs", "Six of Clubs", "Seven of Clubs",
      "Eight of Clubs", "Nine of Clubs", "Ten of Clubs", "Jack of Clubs",
      "Queen of Clubs", "King of Clubs", "Ace of Hearts", "Two of Hearts",
      "Three of Hearts", "Four of Hearts", "Five of Hearts", "Six of Hearts",
      "Seven of Hearts", "Eight of Hearts", "Nine of Hearts", "Ten of Hearts",
      "Jack of Hearts", "Queen of Hearts", "King of Hearts", "Ace of Diamonds",
      "Two of Diamonds", "Three of Diamonds", "Four of Diamonds", "Five of Diamonds",
      "Six of Diamonds", "Seven of Diamonds", "Eight of Diamonds", "Nine of Diamonds",
      "Ten of Diamonds", "Jack of Diamonds", "Queen of Diamonds", "King of Diamonds"]

  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  @doc """
  Shuffle a deck of cards

  ## Examples

      iex> :rand.seed(:exsplus, {101, 102, 103})
      iex> Cards.shuffle(["Ace", "Two", "Three"])
      ["Ace", "Three", "Two"]
      iex> Cards.shuffle(["Ace", "Two", "Three"])
      ["Ace", "Two", "Three"]
      iex> Cards.shuffle(["Ace", "Two", "Three"])
      ["Two", "Ace", "Three"]

  """
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
  Does a given deck contain a given card

  ## Examples

      iex> Cards.contains?(["Ace", "Two", "Three"], "Two")
      true
      iex> Cards.contains?(["Ace", "Two", "Three"], "King")
      false

  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
  Deal a card from a deck, returning the card and the deck with the given card removed

  ## Examples

      iex> Cards.deal(["Ace", "Two", "Three", "Four", "Five"], 2)
      {["Ace", "Two"], ["Three", "Four", "Five"]}

  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  @doc """
  Save a deck to a file

  ## Examples

      iex> Cards.save(["Ace", "Two", "Three", "Four", "Five"], "cards.txt")
      :ok
      iex> File.rm("cards.txt")
      :ok

  """
  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  @doc """
  Load a deck from a file

  ## Examples

      iex> Cards.save(["Ace", "Two", "Three", "Four", "Five"], "cards.txt")
      iex> Cards.load("cards.txt")
      ["Ace", "Two", "Three", "Four", "Five"]
      iex> File.rm("cards.txt")
      :ok

      iex> Cards.load("cards.txt")
      "That file does not exist"

  """
  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, :enoent} -> "That file does not exist"
      {:eror, reason} -> "There was an error reading #{filename} (code: #{reason})"
    end
  end

  @doc """
  Create a deck, shuffle it and deal a hand of a given size

  ## Examples

      iex> :rand.seed(:exsplus, {101, 102, 103})
      iex> {hand, deck} = Cards.create_hand(3)
      iex> hand
      ["Five of Clubs", "Seven of Hearts", "King of Spades"]
      iex> Enum.count(deck)
      49

  """
  def create_hand(hand_size) do
    Cards.create_deck
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end
end
