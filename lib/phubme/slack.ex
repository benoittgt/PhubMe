defmodule PhubMe.Slack do
  def send_private_message({:ok, _comment, [], _sender, _source}) do
    IO.puts "All procceed"
  end

  def send_private_message({:ok, _comment, [], _sender, _source}) do
    IO.puts ""
  end

  def send_private_message({:ok, comment, [nick_head | nick_tail], sender, source}) do
    case Slack.Web.Chat.post_message(List.last(nick_head), formated_message(comment, sender, source), %{token: slack_token}) do
      %{"ok" => false} -> IO.puts "Not matching channel with the nickname " <> List.last(nick_head) <> ". Are you sure it exists?"
      _ -> IO.puts "Matching channel found."
    end
    send_private_message({:ok, comment, nick_tail, sender, source})
  end

  defp formated_message(comment, sender, source) do
    "You've been mentionned on " <> source <> " from " <> sender
  end

  defp slack_token do
    Application.fetch_env!(:slack, :api_token)
  end
end
