defmodule PhubMe.NicknamesMatcher do
  def match_nicknames({full_comment, github_nicknames, sender, comment_parsed}) do
    # IO.inspect comment_parsed
    {:ok, full_comment, matching_nicknames(github_nicknames, [], 0), sender, comment_parsed }
  end

  def match_nicknames(comment_parsed) do
    # IO.inspect comment_parsed
    {:no_nicknames_found}
  end

  defp matching_nicknames([github_nick_head | github_nick_tail], matched_nicknames, array_position) do
    IO.inspect matched_nicknames
    IO.puts nickname_from_mix_config(github_nick_head)
    IO.inspect github_nick_head
    matched_nicknames = List.insert_at(matched_nicknames, array_position, nickname_from_mix_config(github_nick_head))
    matching_nicknames(github_nick_tail, matched_nicknames, array_position + 1)
  end

  defp matching_nicknames([], matched_nicknames, array_position) do
    matched_nicknames
  end

  defp nickname_from_mix_config(github_nick_head) do
    # IO.inspect Application.fetch_env(:phubme, String.to_atom(List.first(github_nick_head)))
    case Application.fetch_env(:phubme, String.to_atom(List.first(github_nick_head))) do
      {:ok, slack_nickname} -> slack_nickname
      :error -> ""
    end
  end
end
