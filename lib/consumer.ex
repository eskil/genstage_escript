defmodule GenstageExample.Consumer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :state_doesnt_matter)
  end

  def init(state) do
    IO.puts "GenstageExample.Consumer, state #{inspect(state)}"
    {:consumer, state}
  end

  def handle_events(events, from, state) do
    IO.puts "GenstageExample.Consumer, state #{inspect(state)}, received #{Enum.count(events)} events from #{inspect(from)}"

    # Consume and process up to "state". This ensures we only process
    # up the specified number and not any extra events that the
    # producer might have produced.
    for event <- Enum.slice(events, 0, state) do
      IO.puts "Consume #{event}"
    end

    # Update state to the new count, and if zero, stop Consumer,
    # otherwise return a :normal :stop.
    new_state = state - Enum.count(events)
    if new_state <= 0 do
      IO.puts "GenstageExample.Consumer stopping"
      {:stop, :normal, new_state}
    else
      {:noreply, [], new_state}
    end
  end
end
