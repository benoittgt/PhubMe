defmodule PhubMe.NicknamesMatcher do
  def match_nicknames({full_comment, github_nicknames, sender, comment_parsed}) do
    {:ok, full_comment, matching_nicknames(github_nicknames, [], 0), sender, comment_parsed }
  end

  def match_nicknames(_) do
    {:no_nicknames_found}
  end

  defp matching_nicknames([github_nick_head | github_nick_tail], matched_nicknames, array_position) do
    if nickname_from_mix_config(github_nick_head) == :error do
      IO.puts "No matching nickname found for " <> List.first(github_nick_head)
    else
      matched_nicknames = List.insert_at(matched_nicknames, array_position, (github_nick_head ++ nickname_from_mix_config(github_nick_head)))
    end
    matching_nicknames(github_nick_tail, matched_nicknames, array_position + 1)
  end

  defp matching_nicknames([], matched_nicknames, _) do
    matched_nicknames
  end

  defp nickname_from_mix_config(github_nick_head) do
    # IO.inspect Application.fetch_env(:phubme, String.to_atom(List.first(github_nick_head)))
    case Application.fetch_env(:phubme, String.to_atom(List.first(github_nick_head))) do
      {:ok, slack_nickname} -> [slack_nickname]
      :error -> :error
    end
  end
end
