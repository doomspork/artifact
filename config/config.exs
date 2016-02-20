use Mix.Config

config :artifact, ArtifactTest,
  asset_url: "/images/:format/:name",
  formats: %{
    preivew: "convert -'[0]' -resize 100x100 -gravity center +repage -strip jpg:-"
  }

config :artifact, ArtifactTest.Storage,
  type: Artifact.Storage.Local,
  storage_dir: Path.expand("../test/tmp", __DIR__)

config :artifact, ArtifactTest.Pool,
  pool_size: 1
