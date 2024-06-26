defmodule Ladder.Dictionary do
  @filename "./priv/words.txt"

  def words do
    @filename
    |> File.read!()
    |> String.split("\n")
  end

  defp index_word(word) do
    word
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(&{&1, word})
  end

  def index_words(words) do
    words
    |> Enum.flat_map(&index_word/1)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end
end
