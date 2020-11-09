# LiveUpload

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `npm install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

# Steps:

1. \$ mix phx.new --version

> Phoenix v1.5.6

1. \$ mix phx.new live_upload --live

   > Fetch and install dependencies: Y

1. \$ cd live_upload

1. \$ mix ecto.create

1. \$ mix phx.server

   > (live dashboard appears to work fine)

1. In mix.exs change dependency to:

   ```
   {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
   ```

1. \$ mix deps.get

   ```
   Dependencies have diverged:
   * phoenix_live_view (https://github.com/phoenixframework/phoenix_live_view.git)
   the dependency phoenix_live_view in mix.exs is overriding a child dependency:

   > In mix.exs:
      {:phoenix_live_view, [env: :prod, git: "https://github.com/phoenixframework/phoenix_live_view.git"]}

   > In deps/phoenix_live_dashboard/mix.exs:
      {:phoenix_live_view, "~> 0.14.3", [env: :prod, hex: "phoenix_live_view", repo: "hexpm", optional: false]}

   Ensure they match or specify one of the above in your deps and set "override: true"
   ** (Mix) Can't continue due to errors on dependencies
   ```

1. Changed mix.exs to:

   ```
   {:phoenix_live_view, github: "phoenixframework/phoenix_live_view", override: true},
   ```

1. \$ mix deps.get

1. Get the latest javascript:

   ```
   npm install --force phoenix_live_view --prefix assets
   ```

1. \$ mix phx.server

   1. open browser to localhost:4000
   1. click on "Live Dashboard"
   1. error (I assume this is because dashboard has not been changed to work with latest liveview)

   ![error](./docs/error.png)

   1. Continuing ...
