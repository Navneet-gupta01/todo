defmodule Todo.Cache do
  use GenServer

  alias Todo.Server

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, list_name) do
      :error ->
        {:ok, new_server} = Todo.Server.start()
        {
          :reply,
          new_server,
          Map.put(todo_servers, list_name, new_server)
        }
      {:ok, server} ->
        {:reply, server, todo_servers}
    end
  end

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def getServerProcess(todo_server_name) do
    GenServer.call(__MODULE__, {:server_process, todo}, 5_000) 
  end
end
