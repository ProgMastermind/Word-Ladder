defmodule Ladder do
  alias Ladder.Server
  @me __MODULE__

  def play(difficulty) do
    Server.start_link({@me, difficulty})

    next_turn(:ok)
  end

  def next_turn(:done), do: :hutza
  def next_turn(:ok) do
    word =
      IO.gets("Move: ")
      |> String.trim()

    @me
    |> Server.turn(word)
    |> next_turn()
  end
end
