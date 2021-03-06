defmodule PewPew.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :pewpew,
      name: "PewPew",
      source_url: "https://github.com/mylanconnolly/pewpew",
      version: @version,
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  defp package do
    [
      name: "pewpew",
      description: "A simple mailgun client for Elixir",
      maintainers: ["Mylan Connolly <mylan.connolly@protonmail.com>"],
      licenses: ["MIT"],
      links: %{"github" => "https://github.com/mylanconnolly/pewpew"}
    ]
  end

  defp docs do
    [main: "PewPew", extras: ["README.md"]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"}
    ]
  end
end
