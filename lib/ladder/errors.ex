defmodule Ladder.Errors do

  alias Ladder.Words

  def list(word, previous) do
    []
    |> maybe_add_error(Words.member?(word), "#{word} is not in our dictionary")
    |> maybe_add_error(Words.correct_length?(word), "#{word} is not four characters")
    |> maybe_add_error(Words.exactly_one_change?(word, previous), "#{word} to #{previous} does not have exactly have one change.")
  end

  def validate(word, previous) do
    case list(word, previous) do
      [] -> {:ok, word}
      errors -> {:error, errors}
    end
  end

  def maybe_add_error(list, false=_valid, error) do
    [error | list]
  end

  def maybe_add_error(list, true=_valid, _error) do
    list
  end
end
