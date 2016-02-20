defmodule Artifact.Supervisor do
  @moduledoc """
  Artifact supervisor
  """

  defmacro __using__(otp_app: otp_app, pool: pool_name, storage: storage_name) do
    quote do
      use Supervisor

      @pool_name unquote(pool_name)
      @storage_name unquote(storage_name)
      @pool_opts Application.get_env(unquote(otp_app), @pool_name, [])
      @storage_opts Application.get_env(unquote(otp_app), @storage_name, []) ++ [name: @storage_name]

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
          size: Keyword.get(@pool_opts, :pool_size, 5),
          max_overflow: Keyword.get(@pool_opts, :max_overflow, 10)
        ]

        children = [
          Supervisor.Spec.worker(Artifact.Storage, [@storage_opts]),
          :poolboy.child_spec(@pool_name, pool_options)
        ]

        supervise(children, strategy: :one_for_one, name: __MODULE__)
      end
    end
  end
end
