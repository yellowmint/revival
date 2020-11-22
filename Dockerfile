FROM elixir:1.11.2-alpine

RUN apk add --no-cache npm inotify-tools

WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force

CMD ["mix", "phx.server"]
