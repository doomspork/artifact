defmodule Artifact.Mixfile do
  use Mix.Project

  @version "0.2.0"

  def project do
    [app: :artifact,
     build_embedded: Mix.env == :prod,
     deps: deps,
     description: """
     File upload and on-the-fly processing for Elixir
     """,
     elixir: "~> 1.2",
     package: package,
     source_url: "https://github.com/doomspork/artifact",
     start_permanent: Mix.env == :prod,
     version: @version]
  end

  def application do
    [applications: [:logger, :porcelain]]
  end

  def package do
    [maintainers: ["Sean Callan"],
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     licenses: ["Apache 2.0"],
     links: %{github: "https://github.com/doomspork/artifact"}]
  end

  def deps do
    [
      {:poolboy, "~> 1.5.1"},
      {:porcelain, "~> 2.0"},
      {:plug, "~> 1.1.1"},

      # Automatic test runner
      {:mix_test_watch, ">= 0.0.0", only: :dev},
      # Style linter
      {:credo, ">= 0.0.0", only: ~w(dev test)a},
    ]
  end
end
