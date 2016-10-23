ExUnit.start

defmodule PhubMeSlack do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  defp full_params_with_one_nick do
    {"comment_with_nicknames", ["@hanaack"], "baxterthehacker", "https://github.com/comment"}
  end

  defp full_params_without_nick do
    {"comment_with_nicknames", [], "baxterthehacker", "https://github.com/comment"}
  end

  defp full_params_with_nicks do
    {"comment_with_nicknames", ["@hanaack", "@lulu"], "baxterthehacker", "https://github.com/comment"}
  end

  defp full_params_with_correct_nicks do
    {"comment_with_nicknames", ["@hannahslack", "@benoit"], "baxterthehacker", "https://github.com/comment"}
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
        PhubMe.Slack.send_private_message(incorrect_payload)
      end) =~ "[PhubMe][Error] Incorrect payload\n"
    end

    test "returns all procceed" do
      assert capture_log(fn ->
        PhubMe.Slack.send_private_message(full_params_without_nick)
      end) =~ "All procceed\n"
    end
  end

  describe "With wrong api_token" do
    test "wrong api token" do
      use_cassette "slack auth issue" do
        assert_raise RuntimeError, "Failed to connect. Are you sure you add correct PHUB_ME_SLACK_API_TOKEN?" , fn ->
          PhubMe.Slack.send_private_message(full_params_with_one_nick)
        end
      end
    end
  end

  describe "With api_token" do
    test "Channel not found" do
      use_cassette "slack channel not found" do
        assert capture_log(fn ->
          PhubMe.Slack.send_private_message(full_params_with_nicks)
        end) =~ ~r(Matching channel found|All procceed)
      end
    end

    test "Channel found" do
      use_cassette "slack channel found" do
        assert capture_log(fn ->
          PhubMe.Slack.send_private_message(full_params_with_correct_nicks)
        end) =~ ~r(Matching channel found|All procceed)
      end
    end
  end
end
