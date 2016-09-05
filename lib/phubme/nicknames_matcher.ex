defmodule PhubMe.NicknamesMatcher do
  def match_nicknames({full_comment, github_nicknames, sender, comment_parsed}) do
    {:ok, full_comment, matching_nicknames(github_nicknames), sender, comment_parsed }
  end

  def match_nicknames(_) do
    {:no_nicknames_found}
  end

  defp matching_nicknames([ [ nickname ] | tail]) do
    case nickname_from_mix_config(nickname) do
      {:ok, matching_nickname} ->
        [ [ nickname, matching_nickname ] | matching_nicknames(tail) ]
      :error ->
        IO.puts "No matching nickname found for " <> nickname
        matching_nicknames(tail)
    end
  end

  defp matching_nicknames([]) do
    []
  end

  defp nickname_from_mix_config(nickname) do
    Application.fetch_env(:phubme, String.to_atom(nickname))
  end
end
