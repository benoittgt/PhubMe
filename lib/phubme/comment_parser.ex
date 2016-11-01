defmodule PhubMe.CommentParser do
  require Logger
  @moduledoc """
  Parse comment and detect if they contains nicknames.
  Every word that start with `@` will be included into `nicknames`.
  `process_comment` returns a struct.
  """
  @nickames_regex ~r{@([A-Za-z0-9_]+)}

  def process_comment(body_params) do
    comment = get_in(body_params, ["comment", "body"])
    sender = get_in(body_params, ["comment", "user", "login"])
    source = get_in(body_params, ["comment", "html_url"])
    nicknames = comment |> extract_nicknames
    Logger.info("Processing comment : \"#{comment}\" from #{sender}")
    %IssueComment{
      source: source,
      comment: comment,
      nicknames: nicknames,
      sender: sender
    }
  end

  defp extract_nicknames(nil) do
    raise "[PhubMe][Error] Not and issue comment"
  end

  defp extract_nicknames(comment) do
    matches = Regex.scan(@nickames_regex, comment, capture: :first)
    matches |> List.flatten
  end
end
