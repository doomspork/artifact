defmodule Artifact.Mixfile do
  use Mix.Project

  @version "0.5.0"

  def project do
    [
      app: :artifact,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      description: "File upload and on-the-fly processing for Elixir",
      elixir: "~> 1.4",
      package: package(),
      source_url: "https://github.com/doomspork/artifact",
      start_permanent: Mix.env() == :prod,
      version: @version
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def package do
    [
      maintainers: ["Sean Callan"],
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["Apache 2.0"],
      links: %{github: "https://github.com/doomspork/artifact"}
    ]
  end

  def deps do
    [
      {:poolboy, "~> 1.5"},
      {:porcelain, "~> 2.0"},
      {:plug, "~> 1.4"}
    ]
  end
end
