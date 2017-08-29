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

You can then create and send a mailer like so:

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

There are a number of functions inside the `PewPew.Mailer` class, and they're
hopefully pretty easy to understand. The functions are designed to be easily
integrated inside a pipeline, so you can modify the struct pretty easily if you
do not have all of the attributes at the time of creation. As an example:

```elixir
PewPew.Mailer.new()
|> PewPew.Mailer.set_to("test@example.com")
|> PewPew.Mailer.set_cc("test@another-example.com")
|> PewPew.Mailer.set_bcc("sneaky@example.com")
|> PewPew.Mailer.set_subject("Hello!")
|> PewPew.Mailer.set_text("This is some text content")
|> PewPew.Mailer.set_html("<p>Some <b>fancy</b> HTML content!</p>")
|> PewPew.Mailer.send()
```

Full documentation for this project can be found at
[https://hexdocs.pm/pewpew](https://hexdocs.pm/pewpew).
