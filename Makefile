setup:
	docker-compose exec phoenix mix ecto.create
	docker-compose exec phoenix mix ecto.migrate
	docker-compose exec phoenix mix run priv/repo/seeds.exs
