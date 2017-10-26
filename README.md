elixir-cnode-example
====================

An example of how to send and receive messages between elixir and cnodes.

Based on https://github.com/remiq/elixir-cnode-example

## Usage

Build

    $ make

First, start iex (starts epmd)

    $ make start_elixir

In another terminal, start the cnode server

    $ make start_server

Send request with Elixir module (src/complex.ex)

    iex> Complex.foo 4

Also, send messages to Elixir node

    iex> Complex.register

    $ make start_client

