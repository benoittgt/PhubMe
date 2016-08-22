defmodule PhubMe.CommentParser do
  def process_comment(body_params) do
    comment = get_in(body_params, ["comment", "body"])
    sender  = get_in(body_params, ["comment", "user", "login"])
    comment_source = get_in(body_params, ["comment", "html_url"])
    IO.puts "Processing comment : \"" <> comment <> "\" from " <> sender
    comment
    |> nicknames_present
    |> extract_nicknames
    |> forward_comment(sender, comment_source) # is it something I can do?
  end

  # public? But if I turn them private how can test them
  def nicknames_present(comment) do
    if Regex.match?(~r{@([A-Za-z0-9_]+)}, comment) do
      {:nicknames_found, comment}
    else
      {:no_nicknames_found, comment}
    end
  end

  def extract_nicknames({:nicknames_found, comment}) do
    nicknames = Regex.scan ~r{@([A-Za-z0-9_]+)}, comment, capture: :first
    {comment, nicknames}
  end

  def extract_nicknames({:no_nicknames_found, _}) do
    IO.puts "No nicknames found in message"
  end

  def forward_comment(first_arg, sender, comment_source) do
    IO.inspect first_arg # I should get the tuple from extract_nicknames no?
    IO.inspect "Ici" <> sender <> comment_source
  end
end
