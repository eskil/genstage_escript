defmodule GenstageExample.Producer do
  use GenStage

  def start_link do
    state = 0
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
    # naming allows us to handle failure
  end
  
  def init(state) do
    IO.puts "GenstageExample.Producer, state: #{inspect(state)}"
    {:producer, state}    
  end

  def handle_demand(demand, state) do
    # Generate resulting events
    events = Enum.to_list(state..state + demand - 1)
    {:noreply, events, (state + demand)}
  end
end
