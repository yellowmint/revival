defmodule Revival.Games.Timer do
  use GenServer
  alias Revival.Games.Timer
  alias Revival.Games

  defstruct [:play_id, :callback, :timeout]

  def start(%Timer{} = state) do
    GenServer.start(__MODULE__, state)
  end

  @impl true
  def init(state) do
    {:ok, state, 3200}
  end

  @impl true
  def handle_cast({:update, play}, state) do
    state.callback.(play)
    {:noreply, state, state.timeout}
  end

  @impl true
  def handle_info(:timeout, state) do
    {command, play} = Games.timeout(state.play_id)
    state.callback.(play)

    case command do
      :next -> {:noreply, state, state.timeout}
      :stop -> {:stop, :play_stopped, state}
    end
  end
end
