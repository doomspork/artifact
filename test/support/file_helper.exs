# Get Mix output sent to the current
# process to avoid polluting tests.
Mix.shell(Mix.Shell.Process)

defmodule FileHelper do
  import ExUnit.Assertions

  def tmp_path do
    Path.expand("../../tmp", __DIR__)
  end

  def in_tmp(which, function) do
    safe = String.replace(which, ~r"[ /]", "")
    path = Path.join(tmp_path, safe)
    File.rm_rf!(path)
    File.mkdir_p!(path)
    File.cd!(path, function)
    File.rm_rf!(path)
  end

  def assert_dir(dir) do
    assert File.dir?(dir), "Expected #{dir} to exist, but does not"
  end

  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to exist, but does not"
  end

  def refute_file(file) do
    refute File.regular?(file), "Expected #{file} to not exist, but it does"
  end

  def assert_file(file, match) do
    cond do
      is_list(match) ->
        assert_file file, &(Enum.each(match, fn(m) -> assert &1 =~ m end))
      is_binary(match) or Regex.regex?(match) ->
        assert_file file, &(assert &1 =~ match)
      is_function(match, 1) ->
        assert_file(file)
        match.(File.read!(file))
    end
  end
end
