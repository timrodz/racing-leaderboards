# Racing Leaderboards

![Screenshot-2026-02-05-09 06 25](https://github.com/user-attachments/assets/47c7c039-27a6-406c-83b2-0f0ff2567a4c)


To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Bootstrap the database

```shell
su - postgres
createdb -E UTF8 racing_leaderboards -l en_US.UTF-8 -T template0
```
