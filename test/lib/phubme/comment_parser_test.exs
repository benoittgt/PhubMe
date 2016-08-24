ExUnit.start

defmodule CommentParser do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

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
      assert capture_io(fn ->
        PhubMe.CommentParser.process_comment(body_params(comment_with_nicknames))
      end) == "Processing comment : \"Hey @HannahArrendt you should take a look at @lucie\" from baxterthehacker\n"
    end

    test "Parse message with two nicknames" do
      assert PhubMe.CommentParser.process_comment(body_params(comment_with_nicknames)) ==
        {comment_with_nicknames, [["@HannahArrendt"], ["@lucie"]], "baxterthehacker", "https://github.com/comment"}
    end

    test "Parse message with no nicknames" do
      assert PhubMe.CommentParser.process_comment(body_params(comment_without_nickname)) ==
        "stop here"
    end
  end
end
