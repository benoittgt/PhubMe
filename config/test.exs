use Mix.Config

config :slack, api_token: System.get_env("PHUBME_SLACK_TOKEN") || "xoxb-75791569751-anZuQDxS7kZ4VqOekromA9yr"
