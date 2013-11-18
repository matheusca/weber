defmodule Cowboy.Test do
  use ExUnit.Case

  test "initialize and shutdown cowboy" do
    # Start cowboy
    { :ok, pid } = Cowboy.start(Weber.Utils.weber_config)

    # Verify if cowboy's up
    assert :erlang.is_process_alive(pid) == true

    # Shutdown Cowboy process
    Cowboy.shutdown

    assert :erlang.is_process_alive(pid) == false
  end
end