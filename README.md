# Artifact

[![Build Status][travis-img]][travis] [![Hex Version][hex-img]][hex] [![License][license-img]][license]

[travis-img]: https://travis-ci.org/doomspork/artifact.png?branch=master
[travis]: https://travis-ci.org/doomspork/artifact
[hex-img]: https://img.shields.io/hexpm/v/artifact.svg
[hex]: https://hex.pm/packages/artifact
[license-img]: http://img.shields.io/badge/license-MIT-brightgreen.svg
[license]: http://opensource.org/licenses/MIT

___There isn't much to see here yet, Artifact is still under active development___

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

1. Add `artifact` to your list of dependencies in `mix.exs`:

	```elixir
	def deps do
	  [{:artifact, "~> 0.1.0"}]
	end
	```
        
## Setup

Define a module to handle your files:

```elixir
defmodule ImageUploader do
  use Artifact, otp_app: :my_app
end
```

We need to add the generated supervisor to our supervisor tree:

```elixir
def start(_type, _args) do
  import Supervisor.Spec, warn: false

  children = [
    supervisor(ImageUploader.Supervisor, [])
  ]

  opts = [strategy: :one_for_one, name: MyApp.Supervisor]
  Supervisor.start_link(children, opts)
end
```

## Configuration

Configure our module:

```elixir
config :my_app, ImageUploader,
  asset_url: "http://www.example.com/images" # defaults to "/images"
```

Lastly, we configure our storage:

```elixir
config :artifact, ImageUploader.Storage,
  type: Artifact.Storage.Local,
  storage_dir: Path.expand("../web/static/assets/images", __DIR__)
```

## Use

```elixir
iex> {:ok, full_path} = ImageUploader.put(data, name: "thumbnail.png")
iex> full_path
"http://www.example.com/images/thumbnail.png"
```

## License

Artifact source code is released under Apache 2.0 License.

See [LICENSE](LICENSE) for more information.
