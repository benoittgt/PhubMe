ExUnit.start

defmodule CommentParser do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  defp comment, do: "Hey @HannahArrendt you should take a look"
  defp body_params do
  %{ "comment" =>
    %{ "body" => comment,
       "user" => %{ "login" => "baxterthehacker"} }}
  end

  describe "PhubMe.CommentParser.process_comment/1" do
    test "Comment properly displayed" do
      assert capture_io(fn ->
        PhubMe.CommentParser.process_comment(body_params)
      end) == "Processing comment : \"Hey @HannahArrendt you should take a look\" from baxterthehacker\n"
    end
  end

  describe "PhubMe.CommentParser.nickname_present/1" do
    test "with a nickname" do
      assert PhubMe.CommentParser.nickname_present(comment) == {:nickname_found, comment}
    end

    test "without a nickname" do
      comment_without_nickame = "Hello Hannah"
      assert PhubMe.CommentParser.nickname_present(comment_without_nickame) == {:no_nickname_found, comment_without_nickame}
    end
  end
end
