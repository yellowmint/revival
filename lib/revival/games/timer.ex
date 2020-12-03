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
    {:ok, state, state.timeout}
  end

  @impl true
  def handle_cast(:touch, state) do
    {:noreply, state, state.timeout}
  end

  @impl true
  def handle_info(:timeout, state) do
    case Games.timeout(state.play_id) do
      {:next, play} ->
        state.callback.(play)
        {:noreply, state, state.timeout}

      {:stop, play} ->
        state.callback.(play)
        {:stop, :play_stopped, state}
    end
  end
end
