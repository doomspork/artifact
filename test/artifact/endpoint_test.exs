defmodule Artifact.EndpointTest do
  use ExUnit.Case
  use Plug.Test

  defmodule BogusEndpoint do
    use Artifact.Endpoint, mod: Artifact.EndpointTest,
                           opts: Application.get_env(:artifact, ArtifactTest)
  end

  test "" do
    resp = :get
           |> conn("/images/original/test.txt")
           |> BogusEndpoint.call([])

    assert resp.state == :sent
    assert resp.status == 200
    assert resp.resp_body == "test"
  end

  def exec(_command, "test"), do: {:ok, "test"}
  def get(_name), do: {:ok, "test"}
end
