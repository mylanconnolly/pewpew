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
