ExUnit.start

defmodule CommentParser do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  defp comment, do: "Hey @HannahArrendt you should take a look"
  defp comment_without_nickame, do: "Hello Hannah"
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

  describe "PhubMe.CommentParser.nicknames_present/1" do
    test "with a nicknames" do
      assert PhubMe.CommentParser.nicknames_present(comment) == {:nicknames_found, comment}
    end

    test "without a nicknames" do
      assert PhubMe.CommentParser.nicknames_present(comment_without_nickame) == {:no_nicknames_found, comment_without_nickame}
    end
  end

  describe "PhubMe.CommentParser.extract_nicknames/2" do
    test "nicknames found" do
      assert PhubMe.CommentParser.extract_nicknames({:nicknames_found, comment}) == {comment, [["@HannahArrendt"]]}
    end

    test "nicknames not found" do
      assert capture_io(fn ->
        PhubMe.CommentParser.extract_nicknames({:no_nicknames_found, comment_without_nickame})
      end) == "No nicknames found in message\n"
    end
  end
end
