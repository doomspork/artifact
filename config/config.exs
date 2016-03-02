use Mix.Config

config :artifact, ArtifactTest,
  asset_url: "/test/:format/:name",
  formats: %{
    test_format: ["upcase", "reverse"]
  }

config :artifact, ArtifactTest.Storage,
  type: Artifact.Storage.Local,
  storage_dir: Path.expand("../test/tmp", __DIR__)

config :artifact, ArtifactTest.Pool,
  pool_size: 1
