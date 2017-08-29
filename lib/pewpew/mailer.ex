defmodule PewPew.Mailer do
  @moduledoc """
  This is the module used to manage the messages themselves.
  """

  defstruct [
    to: [], cc: [], bcc: [], subject: nil, text: nil, html: nil, attach: [],
    from: nil
  ]

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

    - `:from` which specifies the address the email should be sent from. This
      can be used to override the configured default (if there is no configured
      default, then it is required).
    - `:to` which specifies the addresses the email should be sent to. This can
      be a list or single address (no more than 1000 addresses long). This is
      required.
    - `:cc` which specifies the addresses the email should be CCed to. This can
      be a list or single address (no more than 1000 addresses long).
    - `:bcc` which specifies the addresses the email should be BCCed to. This
      can be a list or single address (no more than 1000 addresses long).
    - `:subject` which specifies the subject line on the email. This is
      required.
    - `:text` which specifies the `text/plain` version of the email. Either text
      or html (or both) must be specified.
    - `:html` which specifies the `text/html` version of the email. Either text
      or html (or both) must be specified.
    - `:attach` which specifies any attachments you want on the email.
  """
  def new(opts \\ []) do
    %__MODULE__{}
    |> set_to(Keyword.get(opts, :to, []))
    |> set_cc(Keyword.get(opts, :cc, []))
    |> set_bcc(Keyword.get(opts, :bcc, []))
    |> set_subject(Keyword.get(opts, :subject))
    |> set_text(Keyword.get(opts, :text))
    |> set_html(Keyword.get(opts, :html))
    |> set_attach(Keyword.get(opts, :attach, []))
  end

  @doc """
  This function is used from set the `:from` field in the given struct.
  """
  def set_from(%__MODULE__{} = m, from), do: %{m | from: from}

  @doc """
  This function is used to set the `:to` field in the given struct.
  """
  def set_to(%__MODULE__{} = m, to), do: %{m | to: to}

  @doc """
  This function is used to add to the given addresses to the existing (or empty)
  list of `:to` addresses.
  """
  def add_to(%__MODULE__{to: []} = m, to), do: set_to(m, to)
  def add_to(%__MODULE__{to: [_ | _]} = m, to) when is_binary(to),
    do: %{m | to: [to | m.to]}
  def add_to(%__MODULE__{to: [_ | _]} = m, to) when is_list(to),
    do: %{m | to: to ++ m.to}

  @doc """
  This function is used to set the `:cc` field in the given struct.
  """
  def set_cc(%__MODULE__{} = m, cc), do: %{m | cc: cc}

  @doc """
  This function is used to add to the given addresses to the existing (or empty)
  list of `:cc` addresses.
  """
  def add_cc(%__MODULE__{cc: []} = m, cc), do: set_cc(m, cc)
  def add_cc(%__MODULE__{cc: [_ | _]} = m, cc) when is_binary(cc),
    do: %{m | cc: [cc | m.cc]}
  def add_cc(%__MODULE__{cc: [_ | _]} = m, cc) when is_list(cc),
    do: %{m | cc: cc ++ m.cc}

  @doc """
  This function is used to set the `:bcc` field in the given struct.
  """
  def set_bcc(%__MODULE__{} = m, bcc), do: %{m | bcc: bcc}

  @doc """
  This function is used to add to the given addresses to the existing (or empty)
  list of `:bcc` addresses.
  """
  def add_bcc(%__MODULE__{bcc: []} = m, bcc), do: set_bcc(m, bcc)
  def add_bcc(%__MODULE__{bcc: [_ | _]} = m, bcc) when is_binary(bcc),
    do: %{m | bcc: [bcc | m.bcc]}
  def add_bcc(%__MODULE__{bcc: [_ | _]} = m, bcc) when is_list(bcc),
    do: %{m | bcc: bcc ++ m.bcc}

  @doc """
  This function is used to set the `:subject` field in the given struct.
  """
  def set_subject(%__MODULE__{} = m, subject), do: %{m | subject: subject}

  @doc """
  This function is used to set the `:text` field in the given struct, which
  defines the plaintext version of the email.
  """
  def set_text(%__MODULE__{} = m, text), do: %{m | text: text}

  @doc """
  This function is used to set the `:html` field in the given struct, which
  defines the HTML version of the email.
  """
  def set_html(%__MODULE__{} = m, html), do: %{m | html: html}

  @doc """
  This function is used to set the `:attach` field in the given struct, which
  defines which files should be attached to the email.
  """
  def set_attach(%__MODULE__{} = m, attach), do: %{m | attach: attach}

  @doc """
  This function is used to add to the `:attach` field in the given struct.
  """
  def add_attach(%__MODULE__{attach: []} = m, attach), do: set_attach(m, attach)
  def add_attach(%__MODULE__{attach: [_ | _]} = m, attach) when is_binary(attach),
    do: %{m | attach: [attach | m.attach]}
  def add_attach(%__MODULE__{attach: [_ | _]} = m, attach) when is_list(attach),
    do: %{m | attach: attach ++ m.attach}

  @doc """
  This function is used to send an email, adding any specified attachments, and
  either text or HTML (or both), depending on what was specified.

  If `:to` is a list, we send a batch request, otherwise we send a single
  request.

  For now, if the operation was successful, we return `:ok` (otherwise an
  error tuple is returned).
  """
  def send(%__MODULE__{to: nil}), do: {:error, ":to is a required field"}
  def send(%__MODULE__{subject: nil}),
    do: {:error, ":subject is a required field"}
  def send(%__MODULE__{text: nil, html: nil}),
    do: {:error, "must specify at least one of :text or :html"}
  def send(%__MODULE__{} = m) do
    from = if is_nil(m.from), do: from(), else: m.from
    fields =
      [{"from", from}]
      |> maybe_set("subject", m.subject)
      |> maybe_set("text", m.text)
      |> maybe_set("html", m.html)
      |> attach(m.attach)
      |> batch(m.to)
    headers = [{"Content-Type", "multipart/form-data"}]
    opts = [hackney: [basic_auth: {"api", key()}]]

    case HTTPoison.post(endpoint(), {:multipart, fields}, headers, opts) do
      {:ok, _resp} -> :ok
      {:error, reason} -> {:error, reason}
    end
  end

  # This function is used to set a field if its value is not nil.
  defp maybe_set(fields, _name, value) when is_nil(value), do: fields
  defp maybe_set(fields, name, value), do: [{name, value} | fields]

  # This is the function responsible for delegating the adding of attachments,
  # based on whether it's a string or list.
  defp attach(fields, file) when is_binary(file),
    do: add_attachment(fields, file)
  defp attach(fields, []), do: fields
  defp attach(fields, [file | rest]) do
    fields
    |> add_attachment(file)
    |> attach(rest)
  end

  # This is the function responsible for adding an attachment to the fields.
  defp add_attachment(fields, file) when is_binary(file) do
    name = "attachment"
    data = [name: name, filename: Path.basename(file)]
    [{:file, file, {"form-data", data}, []} | fields]
  end

  # Simple helper to define the recipient variables on the form fields, which
  # allows us to set up a batch send.
  defp batch(fields, to) when is_binary(to), do: [{"to", to} | fields]
  defp batch(fields, to) when is_list(to) do
    vars =
      to
      |> Enum.with_index()
      |> Enum.map(fn {addr, i} -> {addr, %{"id" => i}} end)
      |> Enum.into(%{})
      |> Poison.encode!()
      
    [{"recipient-variables", vars} | fields] ++ Enum.map(to, &({"to", &1}))
  end

  # Simple helper to define the endpoint for mailing messages.
  defp endpoint, do: "#{@mailgun}/#{domain()}/messages"

  # Simple helper to fetch the `from` address in the email.
  defp from, do: Application.get_env(:pewpew, :from)

  # Simple helper to fetch the domain name for the Mailgun account.
  defp domain, do: Application.get_env(:pewpew, :domain)

  # Simple helper to fetch the API key for the Mailgun account.
  defp key, do: Application.get_env(:pewpew, :key)
end
