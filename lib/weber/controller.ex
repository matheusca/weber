defmodule Weber.Controller do

  defmacro __using__(_) do
    quote do
      import Weber.Controller.Layout
      layout('main.html')
      def __purge__ do
        Weber.Reload.purge
      end
    end
  end

end