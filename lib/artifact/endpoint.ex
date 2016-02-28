defmodule Artifact.Endpoint do
  @moduledoc """
  Asset retrieval and transformation endpoint.
  """

  defmacro __using__(mod: module, opts: opts) do
    quote do
      import Plug.Conn
      use Plug.Router

      @artifact unquote(module)
      @opts unquote(opts)

      plug :match
      plug :dispatch

      get @opts[:asset_url] do
        name = var!(name)

        name
        |> @artifact.get
        |> transform(var!(format))
        |> asset_resp(name, var!(conn))
      end

      defp content_type(name) do
        name
        |> Path.extname
        |> String.downcase
        |> Plug.MIME.type
      end

      defp exec(nil, data), do: {:ok, data}
      defp exec(command, data) do
        @artifact.exec(command, data)
      end

      defp extract({:ok, data}), do: data
      defp extract({:error, _reason}), do: nil

      defp asset_resp(nil, _name, conn) do
        send_resp(conn, 404, "File not found.")
      end
      defp asset_resp(data, name, conn) do
        type = content_type(name)

        conn
        |> put_resp_content_type(type)
        |> send_resp(200, data)
      end

      defp transform({:error, _error}, _format), do: nil
      defp transform({:ok, data}, format) do
        @opts
        |> Keyword.get(:formats, %{})
        |> Map.get(String.to_atom(format))
        |> exec(data)
        |> extract
      end
    end
  end
end
