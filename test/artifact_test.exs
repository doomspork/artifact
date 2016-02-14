Code.require_file("support/file_helper.exs", __DIR__)

defmodule ArtifactTest do
  use ExUnit.Case
  use Artifact, otp_app: :artifact

  import FileHelper

  alias Artifact.Storage.Local

  doctest Artifact

  setup do
    Application.put_env(:artifact, ArtifactTest.Storage, type: Local)

    {:ok, pid} = ArtifactTest.Supervisor.start_link
    on_exit(fn -> Process.exit(pid, :kill) end)

    :ok
  end

  test "put/2 stores data" do
    in_tmp "put/2 stores data", fn ->
      assert {:ok, path} = ArtifactTest.put("test", name: "test.txt")
      assert_file path
    end
  end
end
