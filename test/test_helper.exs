Mix.start
Mix.env(:test)
Mix.shell(Mix.Shell.Process)
System.put_env("MIX_ENV", "test")
:application.start(:hackney)

ExUnit.start

defmodule Weber.Test.Helpers do

  def use_config(changes) do
    config = 
      quote do
        def config do
          unquote(changes)
        end
      end
    Module.create Config, config, __ENV__.location
    :ok
  end

  def purge_module(module) do
    :code.delete(module)
    :code.purge(module)
    :ok
  end
end

defmodule MixHelpers do
  import ExUnit.Assertions

  def tmp_path do
    Path.expand("../../tmp", __FILE__)
  end

  def tmp_path(extension) do
    Path.join tmp_path, extension
  end

  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to be a file."
  end

  def assert_directory(dir) do
    assert File.dir?(dir), "Expected #{dir} to be a directory."
  end
end