defmodule Artifact.URLHelpers do
  @moduledoc """
  Helpers for generating Artifact asset urls.
  """

  alias __MODULE__, as: Helpers

  defmacro __using__(opts: opts) do
    defaults = Helpers.default_helpers(opts[:default])

    quote do
      @opts unquote(opts)

      @doc """
      Helper for creating URLs for files and formats.
      """
      @spec url(String.t() | atom) :: String.t()
      def url(name, format \\ :original)

      unquote(defaults)

      def url(name, format) do
        asset_url =
          @opts
          |> Keyword.get(:asset_url, "/images/:format/:name")
          |> String.replace(":format", Atom.to_string(format))
          |> String.replace(":name", name)

        @opts
        |> Keyword.get(:asset_host, "/")
        |> Path.join(asset_url)
      end
    end
  end

  def default_helpers(default) when default in [nil, false] do
    quote do
      def url(nil, _format), do: nil
      def url(:default, _format), do: nil
    end
  end

  def default_helpers(default) do
    quote do
      def url(nil, format), do: url(:default, format)
      def url(:default, format), do: url(unquote(default), format)
    end
  end
end
