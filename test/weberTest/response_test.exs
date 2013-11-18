defmodule WeberHttpResponseTest do
  use ExUnit.Case
  import Weber.Test.Helpers

  setup_all do
    use_config([webserver: [session_manager: false]])
    Cowboy.start(Weber.Utils.weber_config)
    :ok
  end

  teardown_all do
    purge_module(Config)
    Cowboy.shutdown
  end

  test "SimpleResponse test" do
    {:ok, status, _, client} = :hackney.request(:get, 'http://localhost:8080', [], <<>>, [])
    {:ok, body, _} = :hackney.body(client)
    assert(status == 301)
  end

end