defmodule PhubMe.Slack do
  def send_private_message({:error, error_message}) do
    IO.puts "[PhubMe][Error] " <> error_message
  end

  def send_private_message({_comment, [], _sender, _source}) do
    IO.puts "All procceed"
  end

  def send_private_message({ comment, [nick_head | nick_tail], sender, source}) do
    case Slack.Web.Chat.post_message(nick_head, formated_message(comment, sender, source), %{token: slack_token}) do
      %{"error" => "invalid_auth"} -> invalid_slack_auth_message
      %{"ok" => false} -> no_matching_channel_message(nick_head)
      _ -> matching_channel_message
    end
    send_private_message({comment, nick_tail, sender, source})
  end

  defp formated_message(comment, sender, source) do
    "You've been mentionned on " <> source <> " from " <> sender <> ". Comment is : " <> comment
  end

  defp slack_token do
    Application.fetch_env!(:slack, :api_token)
  end

  defp invalid_slack_auth_message do
    raise "Failed to connect. Are you sure you add correct PHUB_ME_SLACK_API_TOKEN?"
  end

  defp no_matching_channel_message(nick) do
    IO.puts "Not matching channel with the nickname "
        <> nick <> ". Are you sure it exists?"
  end

  defp matching_channel_message do
    IO.puts "Matching channel found."
  end
end
