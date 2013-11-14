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
          List.keydelete(Weber.DefaultConfig.config, :session, 0)
        end
      end

    Module.create Config, config, __ENV__.location
    assert Weber.Utils.weber_config == Config.config
  end
end