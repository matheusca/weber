defmodule Handler.WeberReqHandler do

  @moduledoc """
    Weber http request cowboy handler.
  """

  import Weber.Utils
  import Weber.Route
  import Weber.Http.Url

  import Handler.Weber404Handler
  import Handler.WeberReqHandler.Result
  import Handler.WeberReqHandler.Response

  use Weber.Session

  defrecord State,
    cookie:   nil

  def init({:tcp, :http}, req, _opts) do
    session_initialize(req)
    {:ok, req, {} }
  end

  def handle(req, state) do
    # get project root
    {:ok, root} = :file.get_cwd()
    # views directory
    views = root ++ '/lib/views/'
    # static directory
    static = root ++ '/public/'
    # get method
    {method, req2} = :cowboy_req.method(req)
    # get path
    {path, req3} = :cowboy_req.path(req2)

    route = case Code.ensure_loaded?(Route) do
      true -> Route.__route__
      false -> Weber.DefaultRoute.__route__
    end

    # match routes
    case :lists.flatten(match_routes(path, route, method)) do
      [] ->
        # Get static file or page not found
        try_to_find_static_resource(path, static, views, root) |> handle_result |> handle_request(req3, state)
      [{:method, _method}, {:path, matched_path}, {:controller, controller}, {:action, action}] ->
        # Session handler
        case session_handler(weber_config, req3, root) do
          :ok ->
            req4 = req3
          {:req, req4} -> req4
        end

        # get response from controller
        result = Module.function(controller, action, 1).(getAllBinding(path, matched_path))
        # handle controller's response, see in Handler.WeberReqHandler.Result
        handle_result(result, controller, views) |> handle_request(req4, state)
    end
  end

  def terminate(_reason, _req, _state) do
    :ets.delete(:req_storage, self)
    :ok
  end

  #
  #  Try to find static resource and send response
  #
  defp try_to_find_static_resource(path, static, views, _root) do
    resource = List.last(:string.tokens(:erlang.binary_to_list(path), '/'))
    case find_file_path(get_all_files(views), resource) do
      [] ->
        case find_file_path(get_all_files(static), resource) do
          [] ->
            {:not_found, get404, []}
          [resource_name] ->
            {:file, resource_name, []}
        end
      [resource_name] ->
        {:file, resource_name, []}
    end
  end

  #
  # Get accept language
  #
  def get_lang({:undefined, _}) do
    :undefined
  end

  def get_lang({l, _}) do
    [lang | _] = :string.tokens(:erlang.binary_to_list(l), ',')
    :erlang.list_to_binary(lang)
  end

end