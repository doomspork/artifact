defmodule Artifact.EndpointTest do
  use ExUnit.Case
  use Plug.Test

  defmodule BogusEndpoint do
    use Artifact.Endpoint,
      mod: Artifact.EndpointTest,
      opts: Application.get_env(:artifact, ArtifactTest)
  end

  test "returns unaltered file for :original format" do
    resp =
      :get
      |> conn("/test/original/test.txt")
      |> BogusEndpoint.call([])

    assert resp.state == :sent
    assert resp.status == 200
    assert resp.resp_body == "test"
    assert get_resp_header(resp, "content-type") == ["text/plain; charset=utf-8"]
  end

  test "returns processed file for requested format" do
    resp =
      :get
      |> conn("/test/test_format/test.txt")
      |> BogusEndpoint.call([])

    assert resp.state == :sent
    assert resp.status == 200
    assert resp.resp_body == "TSET"
    assert get_resp_header(resp, "content-type") == ["text/plain; charset=utf-8"]
  end

  test "returns 404 for missing format" do
    resp =
      :get
      |> conn("/test/missing_format/test.txt")
      |> BogusEndpoint.call([])

    assert resp.state == :sent
    assert resp.status == 404
  end

  def exec([], data), do: data
  def exec("upcase", data), do: String.upcase(data)
  def exec("reverse", data), do: String.reverse(data)
  def get(_name), do: {:ok, "test"}
end
