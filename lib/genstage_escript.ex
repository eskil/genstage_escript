defmodule Commandline.CLI do
  @moduledoc """
  Example escript with genstage producer/consumer
  
  Starts a producer that produces numbers from "from", and a consumer
  that stops when it has consumed "count" events.
  
  Usage
    --from <start-number>
    --count <number-events>

  Example

  ./genstage_escript --from 0 --count 10
  """
    
  defp help() do
    IO.puts @moduledoc
    System.halt(0)
  end
  
  defp parse_args(args) do
    IO.inspect args, label: "Command Line"
    {options, arguments, invalid} = OptionParser.parse(
      args,
      strict: [
        from: :integer,
        count: :integer,
	help: :boolean
      ],
      aliases: [h: :help]
    )
    IO.inspect arguments, label: "Command Line Arguments"
    IO.inspect options, label: "Command Line Options"
    IO.inspect invalid, label: "Command Line Invalids"
    
    _ = case invalid != [] do
      true  -> help()
      _ -> nil
    end

    case options[:help] do
      true  -> help()
      _ -> {options, arguments, invalid}
    end
  end

  defp process({options, _arguments, _invalid}) do 
    # Setup producer and consumer
    {:ok, producer} = GenStage.start_link(GenstageExample.Producer, options[:from])
    {:ok, consumer} = GenStage.start_link(GenstageExample.Consumer, options[:count])
    {:ok, _subscription} = GenStage.sync_subscribe(consumer,
      to: producer,
      cancel: :permanent,
      min_demand: 5,
      max_demand: 10)
    
    # Wait for consumer to end
    ref = Process.monitor(consumer)
    IO.puts "Main monitors"
    receive do
      {:DOWN, ^ref, _, _, _} ->
	IO.puts "Process #{inspect(consumer)} is down"
    end
    IO.puts "Gentle exit"
  end

  def main(args) do
    args |> parse_args |> process
  end
end
