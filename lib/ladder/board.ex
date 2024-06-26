defmodule Ladder.Board do
  defstruct [:answer, :moves]

  # 1. What is the datatype that will go into the genServer?
  # construct: 2. How do i create it?
  # reduce: 3. How do i transform it?
  # convert: 4. How do i consume it?

  def new({initial_word, answer}) do
    %__MODULE__{answer: answer, moves: [initial_word]}
  end

  def turn(board, word) do
    %{ board | moves: [word | board.moves]}
  end

  def show(board) do
      board.moves
      |> Enum.reverse()
      |> Enum.join(" > ")
      |> maybe_win(board)
  end

  defp maybe_win(moves, board) do
    if won?(board) do
      "You've won!\n" <> moves
    else
      moves <> " > ...#{board.answer}"
    end
  end

  def won?(board), do: board.answer == hd(board.moves)

end
