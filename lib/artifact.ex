defmodule Artifact do
  @moduledoc """
  File upload and manipulation for Elixir
  """

  defmacro __using__(opts) do
    otp_app = Keyword.get(opts, :otp_app)
    unless otp_app, do: raise "Artifact requires an otp_app"

    quote do
      @type opts :: [{atom, any}]
      @type error :: {:error, String.t}
      @type upload :: %{filename: String.t, path: String.t} | any

      @storage_name storage_name = Module.concat(__MODULE__, Storage)
      @opts Application.get_env(unquote(otp_app), __MODULE__, []) ++ unquote(opts)

      defmodule Supervisor do
        @moduledoc false

        @storage Application.get_env(unquote(otp_app), storage_name, []) ++ [name: storage_name]
        use Artifact.Supervisor, storage: @storage,
                                 opts: Application.get_env(unquote(otp_app), __MODULE__, []) ++ unquote(opts)
      end

      @doc """
      For working with `%Plug.Upload` structs.

      See `put/3` for a list of available options.
      """
      @spec put(upload, opts) :: {:ok, String.t} | error
      def put(data, opts \\ [])
      def put(%{filename: name, path: path}, opts) do
        path
        |> File.read!
        |> put(opts ++ [name: name])
      end
      def put(data, opts) do
        result = Artifact.Storage.put(@storage_name, data, opts[:name], opts)

        case result do
          {:error, _reason} = error -> error
          path -> {:ok, url(path)}
        end
      end

      @doc """
      """
      @spec rm(String.t) :: :ok | error
      def rm(name), do: Artifact.Storage.rm(@storage_name, name)

      @doc """
      """
      @spec url(String.t) :: String.t
      def url(name) do
        Path.join(@opts[:asset_url], name)
      end
    end
  end
end
