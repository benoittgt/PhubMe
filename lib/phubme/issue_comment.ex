defmodule IssueComment do
  @moduledoc """
  Struct that is used just after comment parsed :
  * `comment`: The full github comment
  * `nicknames`: Nicknames in the comment. They will be filtered to exclude no-matching
  nicknames.
  * `sender`: The nickname of the sender
  * `source`: The source of the comment (url)
  """
  defstruct [:comment, :nicknames, :sender, :source]
end
