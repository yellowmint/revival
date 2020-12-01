setup:
	docker-compose exec phoenix mix deps.get
	docker-compose exec phoenix mix deps.compile
	docker-compose exec phoenix npm --prefix ./assets install

	docker-compose exec phoenix mix ecto.create
	docker-compose exec phoenix mix ecto.migrate
	docker-compose exec phoenix mix run priv/repo/seeds.exs
