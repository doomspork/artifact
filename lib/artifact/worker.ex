defmodule Artifact.Worker do
  @moduledoc """
  """
  use GenServer

  @doc false
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  @doc """
  """
  def perform(pid, command, data) do
    GenServer.call(pid, {:cli, command, data})
  end

  @doc false
  def init(opts), do: {:ok, opts}

  @doc """
  """
  def handle_call({:cli, command, data}, _from, state) do
    opts = [in: data, out: :iodata]

    result =
      case Porcelain.shell(command, opts) do
        %Porcelain.Result{status: 0, out: out} -> {:ok, IO.iodata_to_binary(out)}
        _ -> {:error, :cli_failure}
      end

    {:reply, result, state}
  end
end
