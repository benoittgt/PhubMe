defmodule PhubMe.NicknamesMatcher do
  def match_nicknames({full_comment, github_nicknames, sender, comment_parsed}) do
    {:ok, full_comment, matching_nicknames(github_nicknames, [], 0), sender, comment_parsed }
  end

  def match_nicknames(comment_parsed) do
    {:no_nicknames_found}
  end

  defp matching_nicknames([h | t], matched_nicknames, array_position) do
    matched_nicknames = List.insert_at(matched_nicknames, array_position, (h ++ nickname_from_mix_config(h)))
    matching_nicknames(t, matched_nicknames, array_position + 1)
  end

  defp matching_nicknames([], matched_nicknames, array_position) do
    matched_nicknames
  end

  defp nickname_from_mix_config(github_nick_head) do
    # IO.inspect Application.fetch_env(:phubme, String.to_atom(List.first(github_nick_head)))
    case Application.fetch_env(:phubme, String.to_atom(List.first(github_nick_head))) do
      {:ok, slack_nickname} -> [slack_nickname]
      :error -> ""
    end
  end
end
