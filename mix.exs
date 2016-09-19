defmodule PhubMe.Mixfile do
  use Mix.Project

  def project do
    [app: :phubme,
     version: "0.0.2",
     elixir: "~> 1.3",
     name: "phubme",
     description: "Notify mentionned github user in slack",
     licences: "MIT",
     maintainers: "Benoit Tigeot",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     preferred_cli_env: [
       vcr: :test, "vcr.delete": :test, "vrc.check": :test, "vcr.show": :test
     ]
   ]
  end

  def application do
    [applications: [:logger, :cowboy, :plug, :poison, :slack],
     mod: {PhubMe.Api, []}]
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
      {:dogma, "~> 0.1", only: :dev},
      {:plug, "~> 1.0"},
      {:slack, "~> 0.7.0"},
      {:websocket_client, git: "https://github.com/jeremyong/websocket_client"}
    ]
  end
end
