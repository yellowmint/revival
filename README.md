# Revival

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


# Setup

Run
```bash
docker-compose up
```

Wait for periodic errors:
```bash
db_1       | 2020-11-22 11:10:28.993 UTC [200] FATAL:  database "revival_dev" does not exist
phoenix_1  | [error] Postgrex.Protocol (#PID<0.4008.0>) failed to connect: ** (Postgrex.Error) FATAL 3D000 (invalid_catalog_name) database "revival_dev" does not exist
```

Then run
```bash
make setup
```

And navigate to http://localhost:4000
