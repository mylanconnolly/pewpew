# PewPew

This is a minimal client for the [mailgun](https://mailgun.com) service.

## Installation

Add to your dependencies:

```elixir
def deps do
  [{:pewpew, "~> 0.1.0"}]
end
```

## Usage

First, set some configuration options in `config.exs` (or the env-specific
version):

```elixir
use Mix.Config

config :pewpew,
  from: "default `from` address",
  key: "your API key from mailgun",
  domain: "the domain you wish to use in mailgun"
```

You can create a mailer like so:

```elixir
# Create a new mailer
m = PewPew.Mailer.new(
  to: "test@example.com",
  subject: "A subject!",
  text: "Plain-text body"
)

# Send the mailer
PewPew.Mailer.send(m)
```

Documentation can be found at
[https://hexdocs.pm/pewpew](https://hexdocs.pm/pewpew).
