Code.require_file("../../support/file_helper.exs", __DIR__)

defmodule Artifact.Storage.LocalTest do
  use ExUnit.Case
  import FileHelper

  alias Artifact.Storage.Local

  test "init/1 creates base dir is missing" do
    in_tmp "init/1 creates base dir is missing", fn ->
      path = Path.join(System.cwd, "test")

      {:ok, opts} = Local.init(storage_dir: path)

      assert [storage_dir: ^path] = opts
      assert_dir path
    end
  end

  test "handle_call/3 for put stores data" do
    in_tmp "handle_call/3 for put stores data", fn ->
      path = Path.join(System.cwd, "test")
      filename = "test.txt"

      opts = [storage_dir: path]
      result = Local.handle_call({:put, "test", filename, []}, self, opts)

      assert {:reply, _name, _state} = result
      assert_file Path.join(path, filename), fn file ->
        assert file =~ ~S|test|
      end
    end
  end
end
