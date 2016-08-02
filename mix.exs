defmodule Phubme.Mixfile do
  use Mix.Project

  def project do
    [app: :phubme,
     version: "0.0.1",
     elixir: "~> 1.2",
     name: "phubme",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     preferred_cli_env: [
       vcr: :test, "vcr.delete": :test, "vrc.check": :test, "vcr.show": :test
     ]
   ]
  end

  def application do
    [[:logger, :httpotion, :cowboy, :plug],
     mod: {Phubme.Api, []}]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8"},
      {:ex_doc,    "~> 0.11"},
      {:earmark,   ">= 0.0.0"},
      {:poison,    "~> 1.5"},
      {:exvcr,     "~> 0.7", only: :test},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:dogma, "~> 0.1", only: :dev},
      {:cowboy, "~> 1.0.3"},
      {:plug, "~> 1.0"},
    ]
  end
end
