defmodule Weber.Utils.Test do
  use ExUnit.Case
  import Weber.Test.Helpers

  teardown_all do
    purge_module(Config)
    :ok
  end

  test "get standard weber's config" do
    assert Weber.Utils.weber_config == Weber.DefaultConfig.config
  end

  test "get users config" do
    use_config([webserver: [session_manager: false]])
    assert Weber.Utils.weber_config[:webserver] == Dict.merge(Weber.Utils.weber_config[:webserver], [session_manager: false])
  end
end