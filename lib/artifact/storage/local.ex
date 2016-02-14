defmodule Artifact.Storage.Local do
  @moduledoc """
  Local filesystem storage
  """

  @behaviour Artifact.Storage

  @type opts :: [{atom, any}]

  @doc """
  Initialize storage instance and override config options
  """
  @spec init(opts) :: opts
  def init(opts \\ []) do
    path = Path.expand(opts[:storage_dir])
    File.mkdir_p!(path)

    opts = Keyword.put(opts, :storage_dir, path)
    {:ok, opts}
  end

  @doc """
  Save data to the filesystem
  """
  def handle_call({:put, data, name, opts}, _from, state) do
    result = name
             |> maybe_mkdir(state ++ opts)
             |> copy_data(data)

    reply = case result do
              :ok -> name
              error -> error
            end

    {:reply, reply, state}
  end

  @doc """
  Remove a file
  """
  @spec remove(String.t, opts) :: :ok | {:error, String.t}
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