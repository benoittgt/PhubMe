ExUnit.start

defmodule NicknamesMatcher do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  defp comment_with_nicknames, do: "Hey @HannahArrendt you should take a look at @lucie"
  defp tuples_with_matching_nicknames do
    {comment_with_nicknames, [["@Hannah"], ["@lucie"]], "baxterthehacker", "https://github.com/comment"}
  end
  defp tuples_with_only_one_matching_nicknames do
    {comment_with_nicknames, [["@Hannah"], ["@luie"]], "baxterthehacker", "https://github.com/comment"}
  end

  describe "PhubMe.NicknamesMatcher.match_nicknames/1" do
    test "no tuples received" do
      assert PhubMe.NicknamesMatcher.match_nicknames("stop here") ==  {:no_nicknames_found}
    end

    test "nicknames received with no matching nickname" do
      assert PhubMe.NicknamesMatcher.match_nicknames(tuples_with_matching_nicknames) ==
        {:ok, comment_with_nicknames, [["@Hannah", "@HannahSlack"], ["@lucie", "@lulu"]], "baxterthehacker", "https://github.com/comment"}
    end

    test "nicknames received with matching nickname" do
      assert PhubMe.NicknamesMatcher.match_nicknames(tuples_with_only_one_matching_nicknames) ==
        {:ok, comment_with_nicknames, [["@Hannah", "@HannahSlack"], ["@luie"]], "baxterthehacker", "https://github.com/comment"}
    end
  end
end
