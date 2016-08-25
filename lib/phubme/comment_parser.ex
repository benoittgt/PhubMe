defmodule PhubMe.CommentParser do
  def process_comment(body_params) do
    comment = get_in(body_params, ["comment", "body"])
    sender  = get_in(body_params, ["comment", "user", "login"])
    comment_source = get_in(body_params, ["comment", "html_url"])
    IO.puts "Processing comment : \"" <> comment <> "\" from " <> sender
    comment = comment
              |> nicknames_present
              |> extract_nicknames
    case comment do
      {:ok, full_comment, nicknames} -> {full_comment, nicknames, sender, comment_source}
      {:error, _} -> "stop here"
    end
  end

  defp nicknames_present(comment) do
    if Regex.match?(~r{@([A-Za-z0-9_]+)}, comment) do
      {:nicknames_found, comment}
    else
      {:no_nicknames_found, comment}
    end
  end

  defp extract_nicknames({:nicknames_found, comment}) do
    nicknames = Regex.scan ~r{@([A-Za-z0-9_]+)}, comment, capture: :first
    {:ok, comment, nicknames}
  end

  defp extract_nicknames({:no_nicknames_found, _}) do
    {:error, "No nicknames found in message"}
  end
end
