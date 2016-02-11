defmodule Artifact.Storage.Local do
  @moduledoc """
  Local filesystem storage
  """

  @behaviour Artifact.Storage

  @type keyword :: [{atom, any}]

  @doc """
  Initialize storage instance and override config options
  """
  @spec init(keyword) :: keyword
  def init(opts \\ []) do
    path = Path.expand(opts[:storage_dir])
    File.mkdir_p!(path)

    opts = Keyword.put(opts, :storage_dir, path)
    {:ok, opts}
  end

  @doc """
  Save data to the filesystem
  """
  @spec put(binary, String.t, keyword) :: {:ok, String.t} | {:error, String.t}
  def put(data, filename, opts) do
    result = filename
              |> maybe_mkdir(opts)
              |> copy_data(data)

    case result do
      :ok -> {:ok, filename}
      error -> error
    end
  end

  @doc """
  Retrieve data at a given filename from the filesystem
  """
  @spec get(String.t, keyword) :: {:ok, binary} | {:error, String.t}
  def get(_name, _opts) do
  end

  @doc """
  Remove a file
  """
  @spec remove(String.t, keyword) :: :ok | {:error, String.t}
  def remove(name, opts) do
    name
    |> full_path(opts)
    |> File.rm
  end

  defp copy_data({:ok, path}, data) do
    File.write(path, data)
  end

  defp copy_data({:error, reason}, _data) do
    {:error, reason}
  end

  defp full_path(path, opts) do
    opts[:storage_dir]
    |> Path.join(path)
    |> Path.expand
  end

  defp maybe_mkdir(path, opts) do
    full_path = full_path(path, opts)

    result = full_path
              |> Path.dirname
              |> File.mkdir_p

    case result do
      :ok -> {:ok, full_path}
      error -> error
    end
  end
end
