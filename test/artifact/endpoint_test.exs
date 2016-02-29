defmodule Artifact.EndpointTest do
  use ExUnit.Case
  use Plug.Test

  defmodule BogusEndpoint do
    use Artifact.Endpoint, mod: Artifact.EndpointTest,
                           opts: Application.get_env(:artifact, ArtifactTest)
  end

  test "returns unaltered file for :original format" do
    resp = :get
           |> conn("/images/original/test.txt")
           |> BogusEndpoint.call([])

    assert resp.state == :sent
    assert resp.status == 200
    assert resp.resp_body == "test"
  end

  test "returns processed file for requested format" do
    resp = :get
           |> conn("/images/preview/test.txt")
           |> BogusEndpoint.call([])

    assert resp.state == :sent
    assert resp.status == 200
    assert resp.resp_body == "TEST"
  end

  test "returns 404 for missing format" do
    resp = :get
           |> conn("/images/missing_format/test.txt")
           |> BogusEndpoint.call([])

    assert resp.state == :sent
    assert resp.status == 404
  end

  def exec(_command, str), do: {:ok, String.upcase(str)}
  def get(_name), do: {:ok, "test"}
end
