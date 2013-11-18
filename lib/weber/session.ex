defmodule Weber.Session do

  def session_initialize(req) do
    if Weber.Utils.weber_config[:webserver][:session_manager] do
      case :ets.lookup(:req_storage, self) do
        [] ->
          :ets.insert(:req_storage, {self, req})
        _  ->
          :ets.delete(:req_storage, self)
          :ets.insert(:req_storage, {self, req})
      end
    end
  end

  def session_handler(config, root, req) do
    # Check cookie
    cookie = case Weber.Http.Params.get_cookie("weber") do
      :undefined ->
        :gen_server.call(:session_manager, {:create_new_session, Weber.Http.Cookie.generate_session_id, self})
      weber_cookie ->
        :gen_server.cast(:session_manager, {:check_cookie, weber_cookie, self})
        weber_cookie
    end

    # set up cookie
    {_, session}  = :lists.keyfind(:session, 1, config)
    {_, max_age}  = :lists.keyfind(:max_age, 1, session)
    req4 = :cowboy_req.set_resp_cookie("weber", cookie, [{:max_age, max_age}], req)

    # get accept language
    lang = case get_lang(:cowboy_req.header("accept-language", req)) do
             :undefined -> "en_US"
             l -> String.replace(l, "-", "_") 
           end

    # check 'lang' process
    locale_process = Process.whereis(binary_to_atom(lang <> ".json"))
    case locale_process do
      nil -> 
        case File.read(:erlang.list_to_binary(root) <> "/deps/weber/lib/weber/i18n/localization/locale/" <> lang <> ".json") do
          {:ok, locale_data} -> Weber.Localization.Locale.start_link(binary_to_atom(lang <> ".json"), locale_data)
          _ -> :ok
        end
      _ -> :ok
    end

    # update accept language
    Weber.Session.Server.set_session_val(:locale, lang)
    {:req, req4}
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