defmodule PewPew.Mailer do
  @moduledoc """
  This is the module used to manage the messages themselves.
  """

  defstruct to: [], subject: nil, text: nil, html: nil, attachments: []

  # The Mailgun API base path.
  @mailgun "https://api.mailgun.net/v3"

  @doc """
  This is the function used to generate a new mailer. It populates the struct
  properly, leaving undefined fields at their default values. Note that if you
  do not specify them here, they will not be sent to the API, for better or for
  worse.

  If you do not wish to specify them here, you can always modify them later on
  using normal struct manipulation.

  The available fields are:

    - `:to` which specifies the addresses the email should be sent to. This can
      be a list or single address (no more than 1000 addresses long).
    - `:subject` which specifies the subject line on the email.
    - `:text` which specifies the `text/plain` version of the email.
    - `:html` which specifies the `text/html` version of the email.
    - `:attachments` which specifies any attachments you want on the email.
  """
  def new(opts \\ []) do
    %__MODULE__{
      to: Keyword.get(opts, :to, []),
      subject: Keyword.get(opts, :subject),
      text: Keyword.get(opts, :text),
      html: Keyword.get(opts, :html),
      attachments: Keyword.get(opts, :attachments, [])
    }
  end

  # Simple helper to define the endpoint for mailing messages.
  defp endpoint, do: "#{@mailgun}/#{domain()}/messages"

  # Simple helper to fetch the `from` address in the email.
  defp from, do: Application.get_env(:pewpew, :from)

  # Simple helper to fetch the domain name for the Mailgun account.
  defp domain, do: Application.get_en(:pewpew, :domain)
end
