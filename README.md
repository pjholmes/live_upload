# Steps:

These are the steps I followed to enable live upload. So far I cannot make it work, but this is certainly my fault.

1. Run the following:

   ```shell
   $ mix phx.new --version

   Phoenix v1.5.6

   $ mix phx.new live_upload --live

   Fetch and install dependencies: Y

   $ cd live_upload

   $ mix ecto.create

   $ mix phx.server
   ```

1. Open a browser to `localhost:4000`
1. Click on "Live Dashboard"

   Dashboard appears to work fine

1. In mix.exs change dependency to:

   ```
   {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
   ```

1. Get dependencies:

   ```
   $ mix deps.get

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

1. Set override to true:

   ```shell
   {:phoenix_live_view, github: "phoenixframework/phoenix_live_view", override: true},
   ```

1. Get dependencies again:

   ```shell
   $ mix deps.get
   ```

1. Get the latest javascript:

   ```shell
   $ npm install --force phoenix_live_view --prefix assets
   ```

1. Start the server again

   ```shell
   $ mix phx.server
   ```

   1. Open browser to localhost:4000
   1. Click on "Live Dashboard"
   1. error (I assume this is because dashboard has not been changed to work with latest liveview)

   ![error](./docs/error.png)

1. Git init and commit

1. Create context, schema and live forms

   ```shell
   $ mix phx.gen.live Blog Post posts title body
   ```

1. Add routes to `lib/live_upload_web/router.ex`

   ```
   live "/posts", PostLive.Index, :index
   live "/posts/new", PostLive.Index, :new
   live "/posts/:id/edit", PostLive.Index, :edit

   live "/posts/:id", PostLive.Show, :show
   live "/posts/:id/show/edit", PostLive.Show, :edit
   ```

1. Migrate and start server

   ```shell
   $ mix ecto.migrate
   $ mix phx.server
   ```

   Added, edited and deleted some posts - appears to work fine

1. Commit

# Upload a File

How hard could it be?

Goal is to add a new file upload to a new blog post (not concerned about edit for now). I followed the steps in `github.com/phoenixframework/phoenix_live_view/guides/server/uploads.md` as well as I could given my understanding.

> Note: It would be ideal if uploads.md document made changes to a live form that had been created using `phx.gen.live`, including the modal, since this could be the starting point for many people. I'm happy to make these changes once I understand it myself.

> Note: It was not clear what `@uploads` is. I don't think one would guess that the call to allow_upload would create an assign named `uploads`. I though it was the entity that the avatar would be associated with (such as my `@post`)

## Allow uploads

1. From the guide: "You enable an upload, typically on mount, via
   [`allow_upload/3`](`Phoenix.LiveView.allow_upload/3`):

   ```elixir
   @impl Phoenix.LiveView
   def mount(_params, _session, socket) do
   {:ok,
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:avatar, accept: ~w(.jpg .jpeg), max_entries: 2)}
   end
   ```

   It seems to me that each time live_modal is called to display the FormComponent, the FormComponent should create a new %uploads, so, I
   put the `assign` and `allow_upload` in the mount function on the component. The component did not have a mount/1. so I added it.

   `lib/live_upload_web/live/post_live/form_component.ex`

   ```elixir
   defmodule LiveUploadWeb.PostLive.FormComponent do
      use LiveUploadWeb, :live_component
      alias LiveUpload.Blog

      @impl true

      def mount(socket) do
      IO.puts("in mount")

      newSocket =
         socket
         |> assign(:uploaded_files, [])
         |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)

      IO.inspect(newSocket, label: "Socket")

      {:ok, newSocket}
   end

   ...
   ```

However, when I run the server, open `/posts`, click on "New Post", click on "Choose File", as soon as I select a file I get an error on the server:

```
[error] GenServer #PID<0.558.0> terminating
** (ArgumentError) no uploads have been allowed
    (phoenix_live_view 0.15.0-dev) lib/phoenix_live_view/upload.ex:166: Phoenix.LiveView.Upload.get_upload_by_ref!/2
    (phoenix_live_view 0.15.0-dev) lib/phoenix_live_view/channel.ex:905: anonymous fn/2 in Phoenix.LiveView.Channel.maybe_update_uploads/2
    (stdlib 3.13.2) maps.erl:233: :maps.fold_1/3
    (phoenix_live_view 0.15.0-dev) lib/phoenix_live_view/channel.ex:174: Phoenix.LiveView.Channel.handle_info/2
    (stdlib 3.13.2) gen_server.erl:680: :gen_server.try_dispatch/4
    (stdlib 3.13.2) gen_server.erl:756: :gen_server.handle_msg/6
    (stdlib 3.13.2) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
Last message: %Phoenix.Socket.Message{event: "event", join_ref: "4", payload: %{"cid" => 2, "event" => "validate", "type" => "form", "uploads" => %{"phx-FkYQ0pNWu8AUeAEC" => [%{"name" => "kyle.jpg", "path" => "avatar", "ref" => "0", "size" => 53482, "type" => "image/jpeg"}]}, "value" => "_csrf_token=KRwlAQIechQhD0s7AG41Qis0DCYlIxl0zZQkqN3PED2wL4ozNkkjTvOA&post%5Btitle%5D=title+1&post%5Bbody%5D=body+1&_target=avatar"}, ref: "8", topic: "lv:phx-FkYQ0hdFr6CpYgDC"}
State: %{components: {%{1 => {LiveUploadWeb.ModalComponent, :modal, %{component: LiveUploadWeb.PostLive.FormComponent, flash: %{}, id: :modal, myself: %Phoenix.LiveComponent.CID{cid: 1}, opts: [id: :new, title: "New Post", action: :new, post: %LiveUpload.Blog.Post{__meta__: #Ecto.Schema.Metadata<:built, "posts">, body: nil, id: nil, inserted_at: nil, title: nil, updated_at: nil}, return_to: "/posts"], return_to: "/posts"}, %{changed: %{}}, {10673596847530257233388001180963798212, %{}}}, 2 => {LiveUploadWeb.PostLive.FormComponent, :new, %{action: :new, changeset: #Ecto.Changeset<action: :validate, changes: %{body: "body 1", title: "title 1"}, errors: [], data: #LiveUpload.Blog.Post<>, valid?: true>, flash: %{}, id: :new, myself: %Phoenix.LiveComponent.CID{cid: 2}, post: %LiveUpload.Blog.Post{__meta__: #Ecto.Schema.Metadata<:built, "posts">, body: nil, id: nil, inserted_at: nil, title: nil, updated_at: nil}, return_to: "/posts", title: "New Post", uploaded_files: [], uploads: %{__phoenix_refs_to_names__: %{"phx-FkYQ0pNWu8AUeAEC" => :avatar}, avatar: #Phoenix.LiveView.UploadConfig<accept: ".jpg,.jpeg,.png", auto_upload?: false, entries: [], errors: [], max_entries: 1, max_file_size: 8000000, name: :avatar, progress_event: nil, ref: "phx-FkYQ0pNWu8AUeAEC", ...>}}, %{changed: %{}}, {36334190098890808283226908231677700255, %{}}}}, %{LiveUploadWeb.ModalComponent => %{modal: 1}, LiveUploadWeb.PostLive.FormComponent => %{new: 2}}, 3}, join_ref: "4", serializer: Phoenix.Socket.V2.JSONSerializer, socket: #Phoenix.LiveView.Socket<assigns: %{flash: %{}, live_action: :new, page_title: "New Post", post: %LiveUpload.Blog.Post{__meta__: #Ecto.Schema.Metadata<:built, "posts">, body: nil, id: nil, ...}, posts: [%LiveUpload.Blog.Post{__meta__: #Ecto.Schema.Metadata<:loaded, "posts">, ...}, %LiveUpload.Blog.Post{...}, ...]}, changed: %{}, endpoint: LiveUploadWeb.Endpoint, id: "phx-FkYQ0hdFr6CpYgDC", parent_pid: nil, root_pid: #PID<0.558.0>, router: LiveUploadWeb.Router, view: LiveUploadWeb.PostLive.Index, ...>, topic: "lv:phx-FkYQ0hdFr6CpYgDC", transport_pid: #PID<0.555.0>}

```

<br><br><br><br><br><br>

# Original README content

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
