defmodule PewPew do
  @moduledoc """
  Documentation for PewPew.
  """

  alias PewPew.Mailer

  @doc """
  This is just a convenience function around `Mailer.new/1`.
  """
  def new_mailer(opts \\ []), do: Mailer.new(opts)
end
