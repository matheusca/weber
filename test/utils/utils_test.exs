defmodule Weber.Utils.Test do
  use ExUnit.Case

  teardown_all do
    :code.delete(Config)
    :code.purge(Config)
    :ok
  end

  test "get standard weber's config" do
    assert Weber.Utils.weber_config == Weber.DefaultConfig.config
  end

  test "get users config" do
    config = 
      quote do
        def config do
          [webserver: [session_manager: false]]
        end
      end

    Module.create Config, config, __ENV__.location
    assert Weber.Utils.weber_config[:webserver] == Dict.merge(Weber.Utils.weber_config[:webserver], [session_manager: false])
  end
end