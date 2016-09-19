defmodule PhubMe.NicknamesMatcher do
  def match_nicknames({_, [], _, _}) do
    {:no_nicknames_found}
  end

  def match_nicknames({full_comment, github_nicknames, sender, comment_parsed}) do
    {full_comment, matching_nicknames(github_nicknames), sender, comment_parsed }
  end

  defp matching_nicknames(list, acc \\ [])

  defp matching_nicknames([nickname | tail], acc) do
    next_acc =
      case nickname_from_mix_config(nickname) do
        nil -> acc
        matching_nickname -> ["@#{matching_nickname}" | acc]
      end
    matching_nicknames(tail, next_acc)
  end

  defp matching_nicknames([], acc) do
    Enum.reverse(acc)
  end

  defp nickname_from_mix_config(nickname) do
    System.get_env(String.trim_leading(nickname, "@"))
  end
end
