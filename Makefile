
up:
	docker-compose up -d

logs:
	docker-compose logs -f

down:
	docker-compose down -v

ps:
	docker-compose ps

paglia:
	docker-compose exec paglia psql -U postgres -d db

newdb:
	docker-compose exec newdb psql -U postgres -d db

restore:
	PGPASSWORD=pass psql -h 127.0.0.1 -p 5555 -U postgres -d db -f database.sql

dump_schema:
	PGPASSWORD=pass pg_dump -s -Ox -h 127.0.0.1 -p 5555 -U postgres -d db > schema.sql

dump_schema_new:
	PGPASSWORD=pass pg_dump -s -Ox -h 127.0.0.1 -p 6666 -U postgres -d db > new-schema.sql

diff: dump_schema dump_schema_new
	colordiff -u schema.sql new-schema.sql

generate:
	liquibase generateChangeLog --changelog-file changelog.xml --url jdbc:postgresql://127.0.0.1:5555/db--username postgres --password pass

status:
	liquibase status --changelog-file changelog.xml --url jdbc:postgresql://127.0.0.1:6666/db --username postgres --password pass

update:
	liquibase update --log-level WARNING --changelog-file changelog.xml --url jdbc:postgresql://127.0.0.1:6666/db --username postgres --password pass

changelogSync:
	liquibase changelogSync --log-level WARNING --changelog-file changelog.xml --url jdbc:postgresql://127.0.0.1:5555/db --username postgres --password pass

reset-newdb:
	docker-compose stop newdb
	docker-compose rm newdb -f
	docker-compose up newdb -d

lb_diff :
	liquibase \
		--outputFile=liquibase_diff.txt \
		--url=jdbc:postgresql://localhost:6666/db \
		--username=postgres \
		--password=pass \
		Diff \
		--referenceUrl=jdbc:postgresql://localhost:5555/db \
		--referenceUsername=postgres \
		--referencePassword=pass
	cat liquibase_diff.txt
