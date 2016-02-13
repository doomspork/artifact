defmodule Artifact.Supervisor do
  @moduledoc """
  Artifact supervisor
  """

  defmacro __using__(storage: storage, opts: opts) do
    quote do
      use Supervisor
      @pool_name Module.concat(__MODULE__, Pool)

      @doc false
      def start_link(_opts \\ []) do
        Supervisor.start_link(__MODULE__, :ok)
      end

      @doc """
      Configure the worker pool and storage, adding both to the supervisor tree.
      """
      def init(:ok) do
        pool_options = [
          name: {:local, @pool_name},
          worker_module: Artifact.Worker,
          size: Keyword.get(unquote(opts), :pool_size, 5),
          max_overflow: Keyword.get(unquote(opts), :max_overflow, 10)
        ]

        children = [
          Supervisor.Spec.worker(Artifact.Storage, [unquote(storage)])
        ]

        supervise(children, strategy: :one_for_one, name: __MODULE__)
      end
    end
  end
end
