defmodule Artifact do
  @moduledoc """
  File upload and manipulation for Elixir.
  """

  defmacro __using__(opts) do
    otp_app = Keyword.get(opts, :otp_app)
    unless otp_app, do: raise "Artifact requires an otp_app"

    quote do
      @type opts :: [{atom, any}]
      @type error :: {:error, String.t}
      @type upload :: %{filename: String.t, path: String.t} | any

      module = __MODULE__
      app_env = Application.get_env(unquote(otp_app), module, [])
      opts = app_env ++ unquote(opts)

      @opts opts
      @pool_name pool_name = Module.concat(module, Pool)
      @storage_name storage_name = Module.concat(module, Storage)

      defmodule Supervisor do
        @moduledoc false
        use Artifact.Supervisor, otp_app: unquote(otp_app),
                                 pool: pool_name,
                                 storage: storage_name
      end

      defmodule Endpoint do
        @moduledoc false

        use Artifact.Endpoint, mod: module, opts: opts
      end

      defmodule URLHelpers do
        @moduledoc false

        use Artifact.URLHelpers, opts: unquote(opts)
      end

      @doc """
      Put binary data or %Plug.Upload{} into the configured storage.
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
          path -> {:ok, path}
        end
      end

      @doc """
      Retrieves data for an asset by its name.
      """
      @spec get(String.t, opts) :: {:ok, String.t} | error
      def get(name, opts \\ []) do
        result = Artifact.Storage.get(@storage_name, name, opts)
        default = Keyword.get(opts, :default, true)
        case result do
          {:error, _reason} when default -> default_data
          {:error, _reason} -> {:error, "missing data"}
          {:ok, _data} -> result
        end
      end

      @doc """
      Remove an asset by name.
      """
      @spec rm(String.t, opts) :: :ok | error
      def rm(name, opts \\ []) do
        Artifact.Storage.rm(@storage_name, name, opts)
      end

      @doc """
      Executes a command in the worker pool.
      """
      def exec(command, data \\ nil) do
        :poolboy.transaction(@pool_name, fn (pid) ->
          Artifact.Worker.perform(pid, command, data)
        end)
      end

      defp default_data do
        case Keyword.get(@opts, :default) do
          nil -> {:error, "missing default value"}
          name ->
            Artifact.Storage.get(@storage_name, name, default: false)
        end
      end
    end
  end
end
