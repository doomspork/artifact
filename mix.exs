defmodule Artifact.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :artifact,
     build_embedded: Mix.env == :prod,
     deps: deps,
     description: """
     File upload and manipulation for Elixir
     """,
     elixir: "~> 1.2",
     package: package,
     source_url: "https://github.com/doomspork/artifact",
     start_permanent: Mix.env == :prod,
     version: @version]
  end

  def application do
    [applications: [:logger]]
  end

  def package do
    [maintainers: ["Sean Callan"],
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     licenses: ["Apache 2.0"],
     links: %{github: "https://github.com/doomspork/artifact"}]
  end

  def deps do
    [
      # Automatic test runner
      {:mix_test_watch, ">= 0.0.0", only: :dev},
      # Style linter
      {:dogma, ">= 0.0.0", only: ~w(dev test)a},
    ]
  end
end
