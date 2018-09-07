defmodule Todo.Server do
  use GenServer

  alias Todo.List

  @impl GenServer
  def init(_) do
     {:ok,Todo.List.new()}
  end

  @impl GenServer
  def handle_call({:get, date},_, state) do
    {
      :reply,
      Todo.List.entries(state, date),
      state
    }
  end

  @impl GenServer
  def handle_cast({:put, entry},state) do
    new_state = Todo.List.add_entry(state, entry)
    {:noreply, new_state}
  end

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def add_entry(todoServer, entry) do
    GenServer.cast(todoServer, {:put, entry})
  end

  def get_enrties(todoServer, date) do
    GenServer.call(todoServer, {:get, date}, 5000)
  end
end
