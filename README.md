<img height="300" src="https://i.imgur.com/p4L31NX.png" align="right" />

# AliceGoodMorning 
[![Hex Version](https://img.shields.io/hexpm/v/alice_good_morning.svg)](https://hex.pm/packages/alice_good_morning) [![Hex Downloads](https://img.shields.io/hexpm/dt/alice_good_morning.svg)](https://hex.pm/packages/alice_good_morning) [![License: MIT](https://img.shields.io/hexpm/l/alice_good_morning.svg)](https://hex.pm/packages/alice_good_morning)




This handler will allow Alice to say good morning to people in different languages.

It does so only once each morning.




## Installation

If [available in Hex](https://hex.pm/packages/alice_good_morning), the package can be installed as:

  1. Add `alice_good_morning` to your list of dependencies in `mix.exs`:

    ```elixir
    defp deps do
       [
         {:websocket_client, github: "jeremyong/websocket_client"},
         {:alice, "~> 0.3"},
         {:alice_good_morning, "~> 1.0"}
       ]
    end
    ```

  2. Add the handler to your list of registered handlers in `mix.exs`:

    ```elixir
    def application do
      [applications: [:alice],
        mod: {
          Alice, [Alice.Handlers.GoodMorning, ...]}]
    end
    ```

## Usage

Use `@alice help` for more information.
