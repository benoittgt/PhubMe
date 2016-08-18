defmodule PhubMe.CommentParser do
  def process_comment(body_params) do
    comment = get_in(body_params, ["comment", "body"])
    sender  = get_in(body_params, ["comment", "user", "login"])
    IO.puts "Processing comment : \"" <> comment <> "\" from " <> sender
    comment
    |> nickname_present
    |> extract_nickname
    # |> foward_comment(sender, comment_source)
  end

  # private?
  def nickname_present(comment) do
    # Use http://elixir-lang.org/docs/stable/elixir/Regex.html#scan/3
    # Regex.scan ~r{@([A-Za-z0-9_]+)}, comment, capture: :first
    if Regex.match?(~r{@([A-Za-z0-9_]+)}, comment) do
      {:nickname_found, comment}
    else
      {:no_nickname_found, comment}
    end
  end

  def extract_nickname({:nickname_found, comment}) do
  end

  def extract_nickname({:no_nickname_found, comment}) do
    IO.puts "handle no nickname_found"
  end
end
