# Artifact

> File upload and on-the-fly processing for Elixir

[![Build Status][travis-img]][travis] [![Hex Version][hex-img]][hex] [![License][license-img]][license]

[travis-img]: https://travis-ci.org/doomspork/artifact.png?branch=master
[travis]: https://travis-ci.org/doomspork/artifact
[hex-img]: https://img.shields.io/hexpm/v/artifact.svg
[hex]: https://hex.pm/packages/artifact
[license-img]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[license]: https://opensource.org/licenses/Apache-2.0

___Artifact is under active development, join the fun!___

## Installation

Add `artifact` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:artifact, "~> 0.1.0"}]
end
```

## Setup in 1-2-3

1. Define a module and `use` Artifact:

	```elixir
	defmodule ImageUploader do
  	  use Artifact, otp_app: :my_app
	end
	```

2. Add the supervisor to your supervisor tree:

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

3. Update your router to include the generated plug:

	```elixir
	forward "/images", ImageUploader.Endpoint
	```

## Configuration

```elixir
config :my_app, ImageUploader,
  asset_host: "http://www.example.com/images",
  asset_url: "/:format/:name",
  formats: %{
    thumb: "convert -'[0]' -resize 50x50 -gravity center +repage -strip jpg:-"
  }

config :artifact, ImageUploader.Storage,
  type: Artifact.Storage.Local,
  storage_dir: Path.expand("../web/static/assets/images", __DIR__)

config :artifact, ImageUploader.Pool,
  pool_size: 1
```

## Use

```elixir
iex> {:ok, name} = ImageUploader.put(data, name: "profile.png")
iex> name
"profile.png"
iex> {:ok, url} = ImageUploader.URLHelpers.url(name, :thumb)
"http://www.example.com/images/thumb/profile.png"
```

## License

Artifact source code is released under Apache 2.0 License.

See [LICENSE](LICENSE) for more information.
