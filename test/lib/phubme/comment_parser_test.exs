ExUnit.start

defmodule CommentParser do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  @body_param %{ "comment" => %{ "body" => "Hey @HannahArrendt you should take a look" }}

  describe "PhubMe.CommentParser.process_comment/1" do
    test "Comment properly displayed" do
      assert capture_io(fn ->
        PhubMe.CommentParser.process_comment(@body_param)
      end) == "Processing comment : \"Hey @HannahArrendt you should take a look\"\n"
    end
  end
end
