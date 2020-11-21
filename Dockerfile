FROM elixir:1.11.2-alpine

RUN apk update && \
  apk add postgresql-client npm inotify-tools

RUN mkdir /app
WORKDIR /app

COPY assets/package.json assets/package-lock.json /app/assets/
RUN cd /app/assets && npm install

COPY mix.exs mix.lock /app/
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

COPY . /app
RUN mix do compile

CMD ["sh", "entrypoint.sh"]
