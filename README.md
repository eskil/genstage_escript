# GenstageEscript

## Description

Basic example of using GenStage from an escript. Either Producer or
Consumer can terminate the flow of events.

The intent is to demonstrate how to run a basic GenStage from escript. Some examples of use

  * webscraper, Producer scrapes, Consumer saves relevant data
  * Producer generates data (images), Consume processes data

## Build

```
mix deps.get
mix deps.compile
mix escript.build
```

## Running

```
./genstage_escript  --from 0 --count 100 --consume 50
Command Line: ["--from", "0", "--count", "50", "--consume", "10"]
%Optimus.ParseResult{
  args: %{},
  flags: %{},
  options: %{consume: 10, count: 50, from: 0},
  unknown: []
}
GenstageExample.Producer, state: {0, 50}
GenstageExample.Consumer, state 10
Main monitors
GenstageExample.Producer, demand 10 from 0 count 50}
GenstageExample.Consumer, state 10, received 5 events from {#PID<0.96.0>, #Reference<0.2528398565.4225236997.58117>}
Consume 0
Consume 1
Consume 2
Consume 3
Consume 4
GenstageExample.Consumer, state 5, received 5 events from {#PID<0.96.0>, #Reference<0.2528398565.4225236997.58117>}
GenstageExample.Producer, demand 5 from 10 count 40}
Consume 5
Consume 6
Consume 7
Consume 8
Consume 9
GenstageExample.Consumer stopping
Process #PID<0.97.0> is down
Gentle exit
```
