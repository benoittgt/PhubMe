# Phubme

[![Build Status](https://travis-ci.org/benoittgt/PhubMe.svg)](https://travis-ci.org/benoittgt/PhubMe)

Notify slack user when you are mentionned in a github comment

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add phubme to your list of dependencies in `mix.exs`:

        def deps do
          [{:phubme, "~> 0.0.1"}]
        end

  2. Ensure phubme is started before your application:

        def application do
          [applications: [:phubme]]
        end

