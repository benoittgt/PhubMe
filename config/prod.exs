use Mix.Config

# config :phubme,
config :slack, api_token: System.get_env("phub_me_slack_api_token") || ""
config :phubme,
"@benoittgt": "@" <> System.get_env("benoittgt") || ""
