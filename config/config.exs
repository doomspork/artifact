use Mix.Config

config :dogma,
  rule_set: Dogma.RuleSet.All,
  override: %{
    LineLength => [max_length: 120],
  }

config :artifact, ArtifactTest,
  asset_url: Path.expand("../test/tmp", __DIR__)

config :artifact, ArtifactTest.Storage,
  type: Artifact.Storage.Local,
  storage_dir: Path.expand("../test/tmp", __DIR__)
