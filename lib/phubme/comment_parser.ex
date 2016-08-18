defmodule PhubMe.CommentParser do
  def process_comment(body_params) do
    comment = get_in(body_params, ["comment", "body"])
    IO.puts "Processing comment : \"" <> comment <> "\""
  end
end
