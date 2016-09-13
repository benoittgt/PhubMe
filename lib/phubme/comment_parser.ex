defmodule PhubMe.CommentParser do
  def process_comment(body_params) do
    comment = get_in(body_params, ["comment", "body"])
    sender = get_in(body_params, ["comment", "user", "login"])
    source = get_in(body_params, ["comment", "html_url"])
    nicknames = comment |> extract_nicknames
    IO.puts "Processing comment : \"#{comment}\" from #{sender}"
    {comment, nicknames, sender, source}
  end

  defp extract_nicknames(comment) do
    matches = Regex.scan(~r{@([A-Za-z0-9_]+)}, comment, capture: :first)
    matches |> List.flatten
  end
end
