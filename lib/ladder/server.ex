defmodule Ladder.Server do
  use GenServer
  alias Ladder.{Board, Words, Errors}

  # client

  # start
  def start_link({name, difficulty}) do
    IO.puts("Starting for #{name}")
    initial = Words.random_word()
    answer = Words.generate(initial, difficulty)

    GenServer.start_link(__MODULE__, {initial, answer},  name: name )
  end

  # make_move
  def turn(pid, word) do
    {status, reply} = GenServer.call(pid, {:turn, word})

    IO.puts(reply)

    status
  end

  # server
  # init
  def init(initial) do
    board = Board.new(initial)
    IO.puts Board.show(board)
    {:ok, board}
  end

  # handle_call
  def handle_call({:turn, word}, _from, board) do
    make_validated_move(board, word)
  end

  defp make_validated_move(board, word) do
    with {:ok, word} <- Errors.validate(word, hd(board.moves)) do
      board
      |> Board.turn(word)
      |> reply_or_finish()
    else
      {:error, errors} ->
        {:reply, {:ok, Enum.join(errors, "\n")}, board}
    end
  end

  def reply_or_finish(board) do
    reply = Board.show(board)
    cond do
      Board.won?(board) -> {:stop, :normal, {:done, reply}, board}
      true -> {:reply, {:ok, reply}, board}
    end
  end
end
