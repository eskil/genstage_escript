defmodule GenstageExample.Consumer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :state_doesnt_matter)
  end

  def init(state) do
    IO.puts "GenstageExample.Consumer, state #{inspect(state)}"
    {:consumer, state}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      IO.puts "Consume #{inspect ({self(), event, state})}"
    end

    new_state = state - Enum.count(events)
    if new_state < 0 do
      {:stop, :normal, new_state}
    else
      {:noreply, [], new_state}
    end
  end
end
