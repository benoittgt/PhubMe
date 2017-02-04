ExUnit.start

defmodule CommentParser do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog

  defp comment_with_nicknames, do: "Hey @HannahArrendt you should take a look at @lucie"
  defp comment_without_nickname, do: "Hello Hannah"
  defp body_params(comment) do
    %{ "comment" =>
      %{ "body" => comment,
        "html_url" => "https://github.com/comment",
        "user" => %{ "login" => "baxterthehacker"} }}
  end

  describe "PhubMe.CommentParser.process_comment/1" do
    test "Comment properly displayed" do
      assert capture_log(fn ->
        PhubMe.CommentParser.process_comment(body_params(comment_with_nicknames()))
    end) =~ "Processing comment : \"Hey @HannahArrendt you should take a look at @lucie\" from baxterthehacker\n"
    end

    test "Parse message with two nicknames" do
      assert PhubMe.CommentParser.process_comment(body_params(comment_with_nicknames())) ==
        %IssueComment{comment: "Hey @HannahArrendt you should take a look at @lucie",
               nicknames: ["@HannahArrendt", "@lucie"],
               sender: "baxterthehacker",
               source: "https://github.com/comment"}
    end

    test "Parse message with no nicknames" do
      assert PhubMe.CommentParser.process_comment(body_params(comment_without_nickname())) ==
        %IssueComment{comment: "Hello Hannah", nicknames: [],
            sender: "baxterthehacker", source: "https://github.com/comment"}
    end

    test "Parse no github message" do
      assert_raise RuntimeError, "[PhubMe][Error] Not and issue comment" , fn ->
        PhubMe.CommentParser.process_comment(%{ "test" => "rescue"})
      end
    end
  end
end
