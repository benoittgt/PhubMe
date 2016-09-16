ExUnit.start

defmodule PhubMeSlack do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  defp full_params_with_nicks do
    {"comment_with_nicknames", ["@hanaack", "@lulu"], "baxterthehacker", "https://github.com/comment"}
  end

  defp full_params_with_correct_nicks do
    {"comment_with_nicknames", ["@hannahslack", "@benoit"], "baxterthehacker", "https://github.com/comment"}
  end

  setup_all do
    HTTPoison.start
  end

  describe "Without api_token" do
    # test "Slack not able to connect"
  end

  describe "With api_token" do
    test "Channel not found" do
      use_cassette "slack channel not found" do
        assert capture_io(fn ->
          PhubMe.Slack.send_private_message(full_params_with_nicks)
        end) == "Not matching channel with the nickname @hanaack. Are you sure it exists?\nNot matching channel with the nickname @lulu. Are you sure it exists?\nAll procceed\n"
      end
    end

    test "Channel found" do
      use_cassette "slack channel found" do
        assert capture_io(fn ->
          PhubMe.Slack.send_private_message(full_params_with_correct_nicks)
        end) == "Matching channel found.\nMatching channel found.\nAll procceed\n"
      end
    end
  end
end
