defmodule WeberTest.Main do

  use Weber.Controller

  layout false

  def redirect_action(_) do
    {:render_inline, "test", [], []}
  end

end