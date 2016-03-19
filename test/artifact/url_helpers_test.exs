defmodule Artifact.URLHelpersTest do
  use ExUnit.Case

  defmodule WithDefault do
    use Artifact.URLHelpers, opts: [default: "default.png"]
  end

  defmodule WithAssetOpts do
    use Artifact.URLHelpers, opts: [asset_host: "http://www.example.com", asset_url: "/:format/:name"]
  end

  defmodule Without do
    use Artifact.URLHelpers, opts: [default: false]
  end

  test "returns a formatted url" do
    assert WithAssetOpts.url("test.png", :thumb) == "http://www.example.com/thumb/test.png"
    assert Without.url("test.png", :thumb) == "/images/thumb/test.png"
  end

  test "returns default filename" do
    assert WithDefault.url(nil) == "/images/original/default.png"
    assert WithDefault.url(:default, :thumb) == "/images/thumb/default.png"
  end

  test "returns nil when default is false" do
    assert Without.url(nil) == nil
    assert Without.url(:default) == nil
  end
end
