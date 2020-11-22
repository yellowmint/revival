# Setup

1. Run
```bash
docker-compose up
```

2. Wait for setup finish indicated by wish to connect to database, this will end with periodic errors:
```bash
db_1       | 2020-11-22 11:10:28.993 UTC [200] FATAL:  database "revival_dev" does not exist
phoenix_1  | [error] Postgrex.Protocol (#PID<0.4008.0>) failed to connect: ** (Postgrex.Error) FATAL 3D000 (invalid_catalog_name) database "revival_dev" does not exist
```

3. Then run this command to fetch dependencies and setup database:
```bash
make setup
```

4. Now navigate to http://localhost:4000
