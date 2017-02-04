defmodule PhubMe.Slack do
  require Logger
  @moduledoc """
  Send message to slack.
  With nicknames, it takes the %IssueComment struct :
  * It sends a message to each nicknames then log "All procceed"

  Without nicknames :
  * It log "All procceed"

  When error :
  * It log the error message
  All logs have specific level that can be defined in mix config per env.
  """

  def send_private_message({:error, error_message}) do
    Logger.error("[PhubMe][Error] " <> error_message)
  end

  def send_private_message(%IssueComment{nicknames: []}) do
    Logger.info("All procceed")
  end

  def send_private_message(%IssueComment{nicknames: [nick_head | nick_tail]}=issue_comment) do
    case Slack.Web.Chat.post_message(nick_head, formated_message(issue_comment), %{token: slack_token()}) do
      %{"error" => "invalid_auth"} -> invalid_slack_auth_message()
      %{"ok" => false} -> no_matching_channel_message(nick_head)
      _ -> matching_channel_message()
    end

    send_private_message(%{ issue_comment | nicknames: nick_tail})
  end

  defp formated_message(%IssueComment{comment: comment, sender: sender, source: source}) do
    "You've been mentionned on " <> source <> " from " <> sender <>
    ". Comment is : " <> comment
  end

  defp slack_token do
    Application.fetch_env!(:slack, :api_token)
  end

  defp invalid_slack_auth_message do
    raise "Failed to connect. Are you sure you add correct PHUB_ME_SLACK_API_TOKEN?"
  end

  defp no_matching_channel_message(nick) do
    Logger.info("Not matching channel with the nickname " <>
                nick <> ". Are you sure it exists?")
  end

  defp matching_channel_message do
    Logger.info("Matching channel found.")
  end
end
