Weber
========

Weber - is a MVC Web framework for [Elixir](http://elixir-lang.org/). 

**Attention in very early stage**

## Features
 
 * MVC web framework;
 * Project generation;
 * Json generation with exjson;
 * Websocket support;

## Quick start

 * Get and install Elixir from master.
 * Clone this repository.
 * Execute `mix deps.get` in the weber directory.
 * Execute `mix compile` in the weber directory.
 * Create new project with: `mix weber /home/user/testWeberApplication`

Now go to the `/home/user/testWeberApplication` and execute there: `mix deps.get && mix compile`. Then you can try to run your testWeberApplication with:

```
./start.sh
```

and go to the http://localhost:8080

For more details see in `examples` directory.

## Directory structure

| Dir/File              | Description                                               |
| --------------------- |:---------------------------------------------------------:| 
|    ./start.sh         | Startup script                                            |
|    ./lib/controllers  | Directory with web controllers                            |
|    ./lib/helpers      | Helper functions                                          |
|    ./lib/models       | Directory for models (ecto)                               |
|    ./lib/static       | Directory for static files (css, js ....)                 |
|    ./lib/views        | Directory with EEx views                                  |
|    ./lib/app.ex       | Application startup settings                              |
|    ./lib/config.ex    | Configuration file.                                       |
|    ./lib/route.ex     | File with routes declaration                              |

## Routing

Routing declaration is in `route.ex` files:

```elixir
    @route on("/", :Simpletodo.Main, :action)
        |> on("/add/:note", :Simpletodo.Main, :add)
```

It is `@route` attribute which value is chain of `on` and `otherwise` functions with 3 parametes:

  * Route path, can be binding (starts with ':' symbol);
  * Module name of controller;
  * Function name from this controller.

## Controllers

Every Weber's controller is just elixir module, like:

```elixir
defmodule Simpletodo.Main do

    import Simplemodel

    def action("GET", []) do
        {:render, [project: "simpleTodo"]}
    end

    def add("POST", [body: body]) do
        new(body)
        {:json, [response: "ok"]}
    end

end
```

Every controller's action passes 2 parametes:

  * Http method
  * List of url bindings  

Controller can returns:

  * `{:render, [project: "simpleTodo"]}` - Render views with the same name as controller and sends it to response.
  * `{:json, [response: "ok"]}` - Weber convert keyword to json and sends it to response.
  * `{:redirect, "/main"}`      - Redirect to the another resource.

## Websocket

You can handle websocket connection and incoming/outcoming websocket message in your controllers.

First of all you need to designate websocket controller in your `config.ex` file in `webserver:` section, like:

```elixir
ws: true,
ws_port: 8800,
ws_mod: :Simplechat.Main.Chat 
```

After it you must implement 3 callbacks in your controller like this:

```elixir
defmodule Simplechat.Main.Chat do

    def websocket_init(pid) do
        #
        # new websocket connection init
        #
    end

    def websocket_message(pid, message) do
        #
        # handle incoming message here
        #
    end

    def websocket_terminate(pid) do
        #
        # connection terminated
        #
    end

end
```

## Dependencies

  * [cowboy](https://github.com/extend/cowboy)
  * [ecto](https://github.com/elixir-lang/ecto)
  * [exjson](https://github.com/guedes/exjson)
  * [mimetypes](https://github.com/spawngrid/mimetypes)

## Contributing

  * Fork current repository
  * Make your changes
  * Send pull request

## Author

[@0xAX](https://twitter.com/0xAX).
