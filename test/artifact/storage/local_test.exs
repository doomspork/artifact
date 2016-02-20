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

  test "handle_call/3 for :put stores data" do
    in_tmp "handle_call/3 for :put stores data", fn ->
      opts = [storage_dir: System.cwd]
      result = Local.handle_call({:put, "test", "test.txt", []}, self, opts)

      assert {:reply, _name, _state} = result
      assert_file  "test.txt", fn file ->
        assert file =~ ~S|test|
      end
    end
  end

  test "handle_cast/2 for :rm removes file" do
    in_tmp "handle_cast/2 for :rm removes file", fn ->
      File.write!("test.txt", "")

      assert_file "test.txt"

      Local.handle_cast({:rm, "test.txt", []}, [storage_dir: System.cwd])

      refute_file "test.txt"
    end
  end
end
