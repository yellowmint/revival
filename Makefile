setup:
	docker-compose run phoenix mix do deps.get, deps.compile
	docker-compose run phoenix npm --prefix ./assets install

	docker-compose run phoenix mix ecto.create
	docker-compose run phoenix mix ecto.migrate
	docker-compose run phoenix mix run priv/repo/seeds.exs
