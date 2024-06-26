defmodule Ladder.Words do
  @words Ladder.Dictionary.words()
  @word_index Ladder.Dictionary.index_words(@words)
  @word_set MapSet.new(@words)

  def random_word, do: Enum.random(@words)

  def move(word) do
    word
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.flat_map(fn {char, pos} -> @word_index[{char, pos}] end)
    |> Enum.random()
  end

  def moves(word) do
    Stream.iterate(word, &move/1)
  end

  def changes(word1, word2) do
    String.graphemes(word1)
    |> Enum.zip(String.graphemes(word2))
    |> Enum.count(fn {x, y} -> x != y end)
  end

  # generate a random answer given a difficulty
  # and exactly num_changes changed letters
  def generate(word, num_changes) do
    moves(word)
    |> Stream.drop_while(fn current ->
      changes(word, current) != num_changes
     end)
    |> Enum.take(1)
    |> List.first()
  end

  def member?(word) do
    MapSet.member?(@word_set, word)
  end

  def correct_length?(word) do
    String.length(word) == 4
  end

  def exactly_one_change?(word, previous) do
    changes(word, previous) == 1
  end


end
