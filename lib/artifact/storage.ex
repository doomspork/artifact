defmodule Artifact.Storage do
  @moduledoc """
  Behaviour for storage implementations
  """

  @type opts :: [{atom, any}]
  @type error :: {:error, any}
  @type reply :: {:reply, any, any}
  @type noreply :: {:noreply, any}

  @callback init(opts) :: opts
  @callback handle_call({:put, binary, String.t, opts}, pid, opts) :: reply
  @callback handle_call({:get, String.t, opts}, pid, opts) :: reply

  @callback handle_cast({:rm, String.t}, opts) :: noreply

  @doc false
  def start_link(opts) do
    GenServer.start_link(opts[:type], opts, name: opts[:name])
  end

  @doc false
  def put(mod, data, name, opts) do
    GenServer.call(mod, {:put, data, name, opts})
  end

  @doc false
  def get(mod, name, opts) do
    GenServer.call(mod, {:get, name, opts})
  end

  @doc false
  def rm(mod, name, opts) do
    GenServer.cast(mod, {:rm, name, opts})
    :ok
  end
end
