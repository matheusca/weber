defmodule Weber do
  use Application.Behaviour

  @moduledoc """
  Main Weber module. Starts Weber application.
  """

  @doc """
  Start new Weber application instance with given
  application name, web application's root
  directory and config from config.ex.
  """
  def run_weber do
    start([], [])
  end

  @doc """
  Start weber application
  """
  def start(_type, _args) do
    config = Weber.Utils.weber_config
    Cowboy.start(config)
    # Manager session
    if session_manager = config[:webserver][:session_manager] do
      :ets.new(:req_storage, [:named_table, :public, :set, {:keypos, 1}])
      session_manager.start_link(config)
      if config[:webserver][:localization] do
        Weber.Localization.LocalizationManager.start_link(config)
      end
    end
  end

  @doc """
  Stop weber application.
  """
  def stop(_state) do
    :ok
  end

end