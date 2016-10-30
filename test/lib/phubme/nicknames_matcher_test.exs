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
    %IssueComment{comment: comment_with_nicknames, nicknames: ["@hannah", "@lucie"], sender: "baxterthehacker", source: "https://github.com/comment"}
  end
  defp tuples_with_no_matching_nicknames do
    %IssueComment{comment: comment_with_nicknames, nicknames: ["@hnnah", "@luie"], sender: "baxterthehacker", source: "https://github.com/comment"}
  end
  defp tuples_with_no_nicknames do
    %IssueComment{comment: comment_without_nickname, nicknames: [], sender: "baxterthehacker", source: "https://github.com/comment"}
  end

  describe "PhubMe.NicknamesMatcher.match_nicknames/1" do
    test "no tuples received" do
      assert PhubMe.NicknamesMatcher.match_nicknames(tuples_with_no_nicknames) ==  {:error, "No nicknames found in this message"}
    end

    test "nicknames received with two matching nicknames" do
      assert PhubMe.NicknamesMatcher.match_nicknames(tuples_with_matching_nicknames) ==
        %IssueComment{source: "https://github.com/comment",
          comment: "Hey @HannahArrendt you should take a look at @lucie",
          nicknames: ["@hannahslack", "@lulu"],
          sender: "baxterthehacker"}
    end

    test "nicknames received with no matching nickname" do
      assert PhubMe.NicknamesMatcher.match_nicknames(tuples_with_no_matching_nicknames) ==
        %IssueComment{source: "https://github.com/comment",
            comment: "Hey @HannahArrendt you should take a look at @lucie",
            nicknames: [], sender: "baxterthehacker"}
    end
  end
end
