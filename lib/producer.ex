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

  # Check if we're done
  def handle_demand(demand, {from, count}) when count <= 0 do
    IO.puts "GenstageExample.Producer, demand #{demand} from #{from} count #{count}}"
    {:stop, :normal, {from, count}}
  end

  # Produce events for min of "demand" and "count" numbers form "from"
  def handle_demand(demand, {from, count}) do
    IO.puts "GenstageExample.Producer, demand #{demand} from #{from} count #{count}}"
    demand = min(demand, count)
    events = Enum.to_list(from..from + demand - 1)
    {:noreply, events, {from + Enum.count(events), count -  + Enum.count(events)}}
  end
end
