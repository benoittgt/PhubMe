ExUnit.start

defmodule PhubMeSlack do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  defp full_params_with_one_nick do
    %IssueComment{source: "https://github.com/comment",
      comment: "comment_with_nicknames",
      nicknames: ["@hanaack"], sender: "baxterthehacker"}
  end

  defp full_params_without_nick do
    %IssueComment{source: "https://github.com/comment",
      comment: "Hey @HannahArrendt you should take a look at @lucie",
      nicknames: [], sender: "baxterthehacker"}
  end

  defp full_params_with_nicks do
    %IssueComment{source: "https://github.com/comment",
      comment: "full comment",
      nicknames: ["@hannahslack", "@lulu"],
      sender: "baxterthehacker"}
  end

  defp full_params_with_correct_nicks do
    %IssueComment{source: "https://github.com/comment",
      comment: "full comment",
      nicknames: ["@hannahslack", "@benoit"],
      sender: "baxterthehacker"}
  end

  defp incorrect_payload do
    {:error, "Incorrect payload"}
  end

  setup_all do
    HTTPoison.start
  end

  describe "Withoud nicks" do
    test "invalide payload" do
      assert capture_log(fn ->
        PhubMe.Slack.send_private_message(incorrect_payload())
      end) =~ "[PhubMe][Error] Incorrect payload\n"
    end

    test "returns all procceed" do
      assert capture_log(fn ->
        PhubMe.Slack.send_private_message(full_params_without_nick())
      end) =~ "All procceed\n"
    end
  end

  describe "With wrong api_token" do
    test "wrong api token" do
      use_cassette "slack auth issue" do
        assert_raise RuntimeError, "Failed to connect. Are you sure you add correct PHUB_ME_SLACK_API_TOKEN?" , fn ->
          PhubMe.Slack.send_private_message(full_params_with_one_nick())
        end
      end
    end
  end

  describe "With api_token" do
    test "Channel not found" do
      use_cassette "slack channel not found" do
        assert capture_log(fn ->
          PhubMe.Slack.send_private_message(full_params_with_nicks())
        end) =~ ~r(with the nickname @hanaack. Are you sure it exists|with the nickname @lulu|All procceed)
      end
    end

    test "Channel found" do
      use_cassette "slack channel found" do
        assert capture_log(fn ->
          PhubMe.Slack.send_private_message(full_params_with_correct_nicks())
        end) =~ ~r(Matching channel found)
      end
    end

    test "account_inactive" do
      use_cassette "account_inactive" do
        assert capture_log(fn ->
          PhubMe.Slack.send_private_message(full_params_with_nicks())
        end) =~ ~r(Slack bot account seems unactivated)
      end
    end
  end
end
