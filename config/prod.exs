use Mix.Config

config :slack, api_token: System.get_env("PHUB_ME_SLACK_API_TOKEN") || "xoxb-7579156***********************omA9yr"
config :logger,
  backends: [:console],
  compile_time_purge_level: :info

