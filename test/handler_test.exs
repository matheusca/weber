defmodule Weber.Handler.Test do
  use ExUnit.Case

  def request do
    {:ok, code, headers, client} = :hackney.request(:get, <<"http://localhost:8080">>, [], <<>>, [])
    client
  end

  test "compile on demand" do
    {:ok, body, client} = :hackney.body(request)
    IO.inspect body
  end
end