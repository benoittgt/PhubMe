# Phubme

[![Build Status](https://travis-ci.org/benoittgt/PhubMe.svg)](https://travis-ci.org/benoittgt/PhubMe)

Notify slack user when you are mentionned in a github comment

## Disclaimer

This is my first Elixir project. I'm looking for reviews and feedbacks about the code. Feel free to open an issue to comment the code or open a pull request.

## Installation

It's [available in Hex](https://hex.pm/packages/phubme/0.0.3). The package can be installed with:

  1. Add phubme to your list of dependencies in `mix.exs`:

        def deps do
          [{:phubme, "~> 0.4.0"}]
        end

  2. Ensure phubme is started before your application:

        def application do
          [applications: [:phubme]]
        end

## Setup

### Slack
To use PhuMe you need to get first a bot token from Slack. [Create one](https://api.slack.com/bot-users) and get the token.
Set this token to the env variables `PHUB_ME_SLACK_API_TOKEN`.

### Nicknames
As slack token. Nicknames need to be set as env variables. **Export variables without `@`** :
```sh
export mynicknameongithub=mynicknameonslack
```

In Heroku it looks like this :

![](heroku_envs.png)

Github nickname on the left, slack nickname on the right.

### Github webhook

Then in github in webhooks add configuration for your Phubme. `https://myserver.io/phubme`, `application/json` only "Issue comment".

Then try it.

Feel free to open issue and PR.

