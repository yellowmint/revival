setup:
	docker-compose run --rm phoenix mix deps.get
	docker-compose run --rm phoenix mix deps.compile
	docker-compose run --rm phoenix npm --prefix ./assets install

	docker-compose run --rm phoenix mix ecto.create
	docker-compose run --rm phoenix mix ecto.migrate
	docker-compose run --rm phoenix mix run priv/repo/seeds.exs
