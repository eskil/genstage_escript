defmodule Commandline.CLI do
  @moduledoc """
  Example escript with genstage producer/consumer

  Starts a producer that produces "count" numbers from "from", and a
  consumer that stops when it has consumed "consume" events.

  The intent is to demonstrate how to use a GenStage from an
  escript. Actual uses could eg. be scrape webpages from the Producer
  and process them in the Consumer.

  The purpose of "from"/"count" separate from "consume" is to
  demonstrate either of them reaching a stop condition and terminating
  the program.

  Usage
    --from <start-number>
    --count <number-events>
    --consume <number-events>

  Example

  ./genstage_escript --from 0 --count 100 --consume 50
  """

  defp parse_args(argv) do
    IO.inspect argv, label: "Command Line"
    Optimus.new!(
      name: "genstage_escript",
      description: "GenStage from CLI demonstration",
      version: "1.0",
      author: "Eskil Olsen",
      about: "Example of how to use GenStage from an escript.",
      allow_unknown_args: false,
      parse_double_dash: true,
      options: [
        from: [
          value_name: "FROM",
          short: "-f",
          help: "Start value for Producer",
          required: false,
          parser: :integer,
          default: 0
        ],
        count: [
          value_name: "COUNT",
          short: "-t",
          help: "Number of values to Produce",
          required: false,
          parser: :integer,
          default: 100
        ],
        consume: [
          value_name: "CONSUME",
          short: "-c",
          help: "Events Consumer should process",
          required: false,
          parser: :integer,
          default: 50
        ]
      ]
    )
    |> Optimus.parse!(argv)
    |> IO.inspect
  end

  defp process(%Optimus.ParseResult{options: options}) do
    # Setup producer and consumer
    {:ok, producer} = GenStage.start_link(GenstageExample.Producer, {options[:from], options[:count]})
    {:ok, consumer} = GenStage.start_link(GenstageExample.Consumer, options[:consume])
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
