Code.require_file("support/file_helper.exs", __DIR__)

defmodule ArtifactTest do
  use ExUnit.Case
  use Artifact, otp_app: :artifact

  import FileHelper

  setup do
    {:ok, pid} = ArtifactTest.Supervisor.start_link
    on_exit(fn -> Process.exit(pid, :kill) end)

    :ok
  end

  test "put/2 stores data" do
    in_tmp "put/2 stores data", fn ->
      assert {:ok, path} = ArtifactTest.put("test", name: "test.txt", storage_dir: System.cwd)
      assert_file path
    end
  end

  test "rm/1 removes data" do
    in_tmp "rm/1 removes data", fn ->
      File.write("test.txt", "test")

      assert_file "test.txt"

      ArtifactTest.rm("test.txt", storage_dir: System.cwd)

      :timer.sleep(1) # We need a tiny delay for the underlying cast to run

      refute_file "test.txt"
    end
  end

  test "get/1 retrieves data" do
    in_tmp "get/1 retrieves data", fn ->
      File.write("test.txt", "test")

      {:ok, data} = ArtifactTest.get("test.txt", storage_dir: System.cwd)

      assert data == "test"
    end
  end

  test "get/1 retrieves default when data missing" do
    in_tmp "get/1 retrieves default when data missing", fn ->
      {:ok, data} = ArtifactTest.get("test.txt", storage_dir: System.cwd)

      assert data == "default text\n"
    end
  end

  test "get/1 returns error with data missing and default false" do
    in_tmp "get/1 retrieves data", fn ->
      {:error, reason} = ArtifactTest.get("test.txt", storage_dir: System.cwd, default: false)

      assert reason == "missing data"
    end
  end

  test "exec/2 runs a command in the pool" do
    {:ok, output} = ArtifactTest.exec("ls")
    assert output =~ "LICENSE"
  end
end
