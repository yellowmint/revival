FROM elixir:1.11.2-alpine

RUN apk add --no-cache npm inotify-tools make gcc libc-dev

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets install

CMD ["mix", "phx.server"]
