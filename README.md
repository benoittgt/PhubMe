# Phubme

[![Build Status](https://travis-ci.org/benoittgt/PhubMe.svg)](https://travis-ci.org/benoittgt/PhubMe)

Notify slack user when you are mentionned in a github comment

## Installation

It's [available in Hex](https://hex.pm/packages/phubme/0.0.3). The package can be installed with:

  1. Add phubme to your list of dependencies in `mix.exs`:

        def deps do
          [{:phubme, "~> 0.0.3"}]
        end

  2. Ensure phubme is started before your application:

        def application do
          [applications: [:phubme]]
        end

## Setup

To use PhuMe you need to get first a bot token from Slack. Create one and get the token.

In you env add ENV variables for slack `PHUB_ME_SLACK_API_TOKEN` as Slack bot token.
Also add nicknames like 'export mynicknameongithub=mynicknameonslack'. **Export variables without `@`.**

Then in github in webhooks add configuration for your Phubme. `https://myserver.io/phubme`, `application/json` only "Issue comment".

Then try it.

Feel free to open issue and PR.

