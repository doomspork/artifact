defmodule Artifact.Storage do
  @moduledoc """
  Behaviour for storage implementations
  """

  @type opts :: [{atom, any}]
  @type error :: {:error, any}
  @type reply :: {:reply, any, any}


  @callback init(opts) :: opts
  @callback handle_call({:put, binary, String.t, opts}, pid, opts) :: reply

  @doc false
  def start_link(opts) do
    GenServer.start_link(opts[:type], opts, name: opts[:name])
  end

  @doc false
  def put(mod, data, name, opts) do
    GenServer.call(mod, {:put, data, name, opts})
  end
end
