ExUnit.start

defmodule NicknamesMatcher do
  use ExUnit.Case, async: true

  setup_all do
    System.put_env("hannah", "hannahslack")
    System.put_env("lucie", "lulu")
  end

  defp comment_with_nicknames, do: "Hey @HannahArrendt you should take a look at @lucie"
  defp comment_without_nickname, do: "Hello Hannah"
  defp tuples_with_matching_nicknames do
    {comment_with_nicknames, ["@hannah", "@lucie"], "baxterthehacker", "https://github.com/comment"}
  end
  defp tuples_with_no_matching_nicknames do
    {comment_with_nicknames, ["@hnnah", "@luie"], "baxterthehacker", "https://github.com/comment"}
  end
  defp tuples_with_no_nicknames do
    {comment_without_nickname, [], "baxterthehacker", "https://github.com/comment"}
  end

  describe "PhubMe.NicknamesMatcher.match_nicknames/1" do
    test "no tuples received" do
      assert PhubMe.NicknamesMatcher.match_nicknames(tuples_with_no_nicknames) ==  {:no_nicknames_found}
    end

    test "nicknames received with two matching nicknames" do
      assert PhubMe.NicknamesMatcher.match_nicknames(tuples_with_matching_nicknames) ==
        {comment_with_nicknames, ["@hannahslack", "@lulu"], "baxterthehacker", "https://github.com/comment"}
    end

    test "nicknames received with no matching nickname" do
      assert PhubMe.NicknamesMatcher.match_nicknames(tuples_with_no_matching_nicknames) ==
        {comment_with_nicknames, [], "baxterthehacker", "https://github.com/comment"}
    end
  end
end
