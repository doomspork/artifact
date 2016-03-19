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
  [{:artifact, "~> 0.4"}]
end
```

## Setup in 1-2-3

1. Define a module and `use` Artifact:

	```elixir
	defmodule ExampleUploader do
  	  use Artifact, otp_app: :my_app
	end
	```

2. Add the supervisor to your supervisor tree:

	```elixir
	def start(_type, _args) do
  	  import Supervisor.Spec, warn: false

  	  children = [
    	 supervisor(ExampleUploader.Supervisor, [])
  	  ]

  	  opts = [strategy: :one_for_one, name: MyApp.Supervisor]
     Supervisor.start_link(children, opts)
   end
   ```

3. Update your router to include the generated plug:

	```elixir
	forward "/images", ExampleUploader.Endpoint
	```

## Configuration

```elixir
config :my_app, ExampleUploader,
  asset_host: "http://www.example.com/images",
  asset_url: "/:format/:name",
  default: "placeholder.png",
  formats: %{
    thumb: "convert -'[0]' -resize 50x50 -gravity center +repage -strip jpg:-"
  }

config :my_app, ExampleUploader.Storage,
  type: Artifact.Storage.Local,
  storage_dir: Path.expand("../web/static/assets/images", __DIR__)

config :my_app, ExampleUploader.Pool,
  pool_size: 1
```

## Use

```elixir
iex> {:ok, name} = ExampleUploader.put(data, name: "profile.png")
iex> name
"profile.png"
iex> {:ok, url} = ExampleUploader.URLHelpers.url(name, :thumb)
"http://www.example.com/images/thumb/profile.png"
```

## Phoenix Integration

Using Aritfact with Phoenix?  It may be helpful to update your `web/web.ex` to alias or import the uploader's url helpers:

```elixir
def view do
  quote do
    use Phoenix.View, root: "web/templates"

    import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

    use Phoenix.HTML

    # We'll use an alias with a shorter name
    alias ExampleUploader.URLHelpers, as: Images

    import BevReviews.Router.Helpers
    import BevReviews.ErrorHelpers
    import BevReviews.Gettext
  end
end
```

Now we can generate URLs in our markup:

```erb
<img class="img-responsive img-thumb" src="<%= Images.url(user.avatar, :thumb) %>" alt="">
```

## License

Artifact source code is released under Apache 2.0 License.

See [LICENSE](LICENSE) for more information.
