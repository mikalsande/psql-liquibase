## Prerequisites

You will need
* docker
* docker-compose
* liquibase
* pg_dump
* pg_restore


The example database in database.sql is the paglia database from:
* https://www.postgresqltutorial.com/wp-content/uploads/2019/05/dvdrental.zip

## Get started using existing changelog.xml

Spin up postgres containers
```
$ make up  
docker-compose up -d
[+] Running 3/3
 ⠿ Network psql-liquibase_default  Created                                                                                                              0.0s
 ⠿ Container newdb                 Started                                                                                                              0.3s
 ⠿ Container paglia                Started                                                                                                              0.3s
```

Restore the database.
```
$ make restore
PGPASSWORD=pass psql -h 127.0.0.1 -p 5555 -U postgres -d db -f database.sql
SET
SET
SET
SET
SET
...
```

Log into the paglia database and check that the data is there.
```
$ make paglia 
docker-compose exec paglia psql -U postgres -d db
psql (13.5 (Debian 13.5-1.pgdg110+1))
Type "help" for help.

db=# \dt
             List of relations
 Schema |     Name      | Type  |  Owner   
--------+---------------+-------+----------
 public | actor         | table | postgres
 public | address       | table | postgres
 public | category      | table | postgres
 public | city          | table | postgres
 public | country       | table | postgres
 public | customer      | table | postgres
 public | film          | table | postgres
 public | film_actor    | table | postgres
 public | film_category | table | postgres
 public | inventory     | table | postgres
 public | language      | table | postgres
 public | payment       | table | postgres
 public | rental        | table | postgres
 public | staff         | table | postgres
 public | store         | table | postgres
(15 rows)
```


Check status for the new database.
```
$ make status     
liquibase status --changelog-file changelog.xml --url jdbc:postgresql://127.0.0.1:6666/db --username postgres --password pass
####################################################
##   _     _             _ _                      ##
##  | |   (_)           (_) |                     ##
##  | |    _  __ _ _   _ _| |__   __ _ ___  ___   ##
##  | |   | |/ _` | | | | | '_ \ / _` / __|/ _ \  ##
##  | |___| | (_| | |_| | | |_) | (_| \__ \  __/  ##
##  \_____/_|\__, |\__,_|_|_.__/ \__,_|___/\___|  ##
##              | |                               ##
##              |_|                               ##
##                                                ## 
##  Get documentation at docs.liquibase.com       ##
##  Get certified courses at learn.liquibase.com  ## 
##  Free schema change activity reports at        ##
##      https://hub.liquibase.com                 ##
##                                                ##
####################################################
Starting Liquibase at 13:04:02 (version 4.7.0 #1140 built at 2022-01-07 19:26+0000)
Liquibase Version: 4.7.0
Liquibase Community 4.7.0 by Liquibase
73 change sets have not been applied to postgres@jdbc:postgresql://127.0.0.1:6666/db
Liquibase command 'status' was executed successfully.
```

Update the newdb using the generated changelog.
```
$ make update
liquibase update --log-level WARNING --changelog-file changelog.xml --url jdbc:postgresql://127.0.0.1:6666/db --username postgres --password pass
####################################################
##   _     _             _ _                      ##
##  | |   (_)           (_) |                     ##
##  | |    _  __ _ _   _ _| |__   __ _ ___  ___   ##
##  | |   | |/ _` | | | | | '_ \ / _` / __|/ _ \  ##
##  | |___| | (_| | |_| | | |_) | (_| \__ \  __/  ##
##  \_____/_|\__, |\__,_|_|_.__/ \__,_|___/\___|  ##
##              | |                               ##
##              |_|                               ##
##                                                ## 
##  Get documentation at docs.liquibase.com       ##
##  Get certified courses at learn.liquibase.com  ## 
##  Free schema change activity reports at        ##
##      https://hub.liquibase.com                 ##
##                                                ##
####################################################
Starting Liquibase at 13:04:24 (version 4.7.0 #1140 built at 2022-01-07 19:26+0000)
Liquibase Version: 4.7.0
Liquibase Community 4.7.0 by Liquibase
Liquibase command 'update' was executed successfully.
```

Add changelog to the existing (paglia) database.
```
$ make changelogSync
liquibase changelogSync --log-level WARNING --changelog-file changelog.xml --url jdbc:postgresql://127.0.0.1:5555/db --username postgres --password pass
####################################################
##   _     _             _ _                      ##
##  | |   (_)           (_) |                     ##
##  | |    _  __ _ _   _ _| |__   __ _ ___  ___   ##
##  | |   | |/ _` | | | | | '_ \ / _` / __|/ _ \  ##
##  | |___| | (_| | |_| | | |_) | (_| \__ \  __/  ##
##  \_____/_|\__, |\__,_|_|_.__/ \__,_|___/\___|  ##
##              | |                               ##
##              |_|                               ##
##                                                ## 
##  Get documentation at docs.liquibase.com       ##
##  Get certified courses at learn.liquibase.com  ## 
##  Free schema change activity reports at        ##
##      https://hub.liquibase.com                 ##
##                                                ##
####################################################
Starting Liquibase at 13:06:30 (version 4.7.0 #1140 built at 2022-01-07 19:26+0000)
Liquibase Version: 4.7.0
Liquibase Community 4.7.0 by Liquibase
Liquibase command 'changelogSync' was executed successfully.
```

Diff the existing (paglia) and newly created database (newdb).
```
$ make lb_diff         
liquibase \
                --outputFile=liquibase_diff.txt \
                --url=jdbc:postgresql://localhost:5555/db \
                --username=postgres \
                --password=pass \
                Diff \
                --referenceUrl=jdbc:postgresql://localhost:6666/db \
                --referenceUsername=postgres \
                --referencePassword=pass
####################################################
##   _     _             _ _                      ##
##  | |   (_)           (_) |                     ##
##  | |    _  __ _ _   _ _| |__   __ _ ___  ___   ##
##  | |   | |/ _` | | | | | '_ \ / _` / __|/ _ \  ##
##  | |___| | (_| | |_| | | |_) | (_| \__ \  __/  ##
##  \_____/_|\__, |\__,_|_|_.__/ \__,_|___/\___|  ##
##              | |                               ##
##              |_|                               ##
##                                                ## 
##  Get documentation at docs.liquibase.com       ##
##  Get certified courses at learn.liquibase.com  ## 
##  Free schema change activity reports at        ##
##      https://hub.liquibase.com                 ##
##                                                ##
####################################################
Starting Liquibase at 13:07:09 (version 4.7.0 #1140 built at 2022-01-07 19:26+0000)
Liquibase Version: 4.7.0
Liquibase Community 4.7.0 by Liquibase

Diff Results:
Output saved to /Users/mikalsande/Documents/GitHub/psql-liquibase/liquibase_diff.txt
Liquibase command 'diff' was executed successfully.
cat liquibase_diff.txt
Reference Database: postgres @ jdbc:postgresql://localhost:6666/db (Default Schema: public)
Comparison Database: postgres @ jdbc:postgresql://localhost:5555/db (Default Schema: public)
Compared Schemas: public
Product Name: EQUAL
Product Version: EQUAL
Missing Catalog(s): NONE
Unexpected Catalog(s): NONE
Changed Catalog(s): NONE
Missing Column(s): NONE
Unexpected Column(s): NONE
Changed Column(s): 
     public.actor.actor_id
          defaultValue changed from 'null' to 'nextval('actor_actor_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.address.address_id
          defaultValue changed from 'null' to 'nextval('address_address_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.category.category_id
          defaultValue changed from 'null' to 'nextval('category_category_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.city.city_id
          defaultValue changed from 'null' to 'nextval('city_city_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.country.country_id
          defaultValue changed from 'null' to 'nextval('country_country_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.customer.customer_id
          defaultValue changed from 'null' to 'nextval('customer_customer_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.film.film_id
          defaultValue changed from 'null' to 'nextval('film_film_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.inventory.inventory_id
          defaultValue changed from 'null' to 'nextval('inventory_inventory_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.language.language_id
          defaultValue changed from 'null' to 'nextval('language_language_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.payment.payment_id
          defaultValue changed from 'null' to 'nextval('payment_payment_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.rental.rental_id
          defaultValue changed from 'null' to 'nextval('rental_rental_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.staff.staff_id
          defaultValue changed from 'null' to 'nextval('staff_staff_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
     public.store.store_id
          defaultValue changed from 'null' to 'nextval('store_store_id_seq'::regclass)'
          type changed from 'int4' to 'serial'
...
```

The open source version of liquidbase does not track postgresql functions. For a more complete
picture of the difference between the original and created database we can diff their schemas.
```
$ make diff           
PGPASSWORD=pass pg_dump -s -Ox -h 127.0.0.1 -p 5555 -U postgres -d db > schema.sql
PGPASSWORD=pass pg_dump -s -Ox -h 127.0.0.1 -p 6666 -U postgres -d db > new-schema.sql
colordiff -u schema.sql new-schema.sql
--- schema.sql  2022-01-16 13:40:29.574832833 +0100
+++ new-schema.sql      2022-01-16 13:40:30.085417253 +0100
@@ -53,259 +53,6 @@
 
 
 --
--- Name: film_in_stock(integer, integer); Type: FUNCTION; Schema: public; Owner: -
---
-
-CREATE FUNCTION public.film_in_stock(p_film_id integer, p_store_id integer, OUT p_film_count integer) RETURNS SETOF integer
-    LANGUAGE sql
-    AS $_$
-     SELECT inventory_id
-     FROM inventory
-     WHERE film_id = $1
-     AND store_id = $2
-     AND inventory_in_stock(inventory_id);
-$_$;
...
```

## Generate a new changelog.xml

Start clean.
```
make down
make up
make restore
```

Create a schema only dump that we can use to look up missing objects from Liquibase errors.
```
$ make dump_schema
PGPASSWORD=pass pg_dump -s -h 127.0.0.1 -p 5555 -U postgres -d db > schema.sql
```

Generate the changelog
```
make generate
```

Try to apply the changelog to an empty database (newdb).
```
make update
```


## Fix tables that use SERIAL

* Remove `autoIncrement="true"` from the column definition
* Add an `addAutoIncrement` to the column below the table in the same changeSet

Example:
```
    <changeSet author="mikalsande (generated)" id="1642327687659-1">
        <createTable tableName="customer">
            <column name="customer_id" type="INTEGER">
                <constraints nullable="false" primaryKey="true" primaryKeyName="customer_pkey"/>
            </column>
            <column name="store_id" type="SMALLINT">
                <constraints nullable="false"/>
            </column>
            <column name="first_name" type="VARCHAR(45)">
                <constraints nullable="false"/>
            </column>
            <column name="last_name" type="VARCHAR(45)">
                <constraints nullable="false"/>
            </column>
            <column name="email" type="VARCHAR(50)"/>
            <column name="address_id" type="SMALLINT">
                <constraints nullable="false"/>
            </column>
            <column defaultValueBoolean="true" name="activebool" type="BOOLEAN">
                <constraints nullable="false"/>
            </column>
            <column defaultValueComputed="('now'::text)::date" name="create_date" type="date">
                <constraints nullable="false"/>
            </column>
            <column defaultValueComputed="now()" name="last_update" type="TIMESTAMP WITHOUT TIME ZONE"/>
            <column name="active" type="INTEGER"/>
        </createTable>
        <addAutoIncrement columnDataType="int" columnName="customer_id" incrementBy="1" startWith="1" tableName="customer"/>
    </changeSet>
```
## Process to create a working changelog

The general process is
* Run Liquibase update with `make update`
* Get an error, found the changeSet id
* Grep after the missing type in `schema.sql`
* Update `changelog.xml`

### First error
Error:
```
Unexpected error running Liquibase: ERROR: type "year" does not exist
  Position: 146 [Failed SQL: (0) CREATE TABLE public.film (film_id INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL, title VARCHAR(255) NOT NULL, description TEXT, release_year YEAR(10), language_id SMALLINT NOT NULL, rental_duration SMALLINT DEFAULT 3 NOT NULL, rental_rate numeric(4, 2) DEFAULT 4.99 NOT NULL, length SMALLINT, replacement_cost numeric(5, 2) DEFAULT 19.99 NOT NULL, rating MPAA_RATING DEFAULT 'G', last_update TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, special_features TEXT[], fulltext TSVECTOR NOT NULL, CONSTRAINT film_pkey PRIMARY KEY (film_id))]
```

Missing SQL
```
CREATE DOMAIN public.year AS integer CONSTRAINT year_check CHECK (((VALUE >= 1901) AND (VALUE <= 2155)));
```

Missing changelog xml
```
    <changeSet author="manual" id="1642327687659-32.1">
        <sqlFile dbms="all" encoding="utf8" endDelimiter=";" path="domain-year.sql" relativeToChangelogFile="true" splitStatements="true" stripComments="true"/>
    </changeSet>
```

Must also change `YEAR(10)` to `YEAR`.

### Second error

Error:
```
[2022-01-16 12:03:20] SEVERE [liquibase.integration] ERROR: type "mpaa_rating" does not exist
  Position: 356 [Failed SQL: (0) CREATE TABLE public.film (film_id INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL, title VARCHAR(255) NOT NULL, description TEXT, release_year YEAR, language_id SMALLINT NOT NULL, rental_duration SMALLINT DEFAULT 3 NOT NULL, rental_rate numeric(4, 2) DEFAULT 4.99 NOT NULL, length SMALLINT, replacement_cost numeric(5, 2) DEFAULT 19.99 NOT NULL, rating MPAA_RATING DEFAULT 'G', last_update TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, special_features TEXT[], fulltext TSVECTOR NOT NULL, CONSTRAINT film_pkey PRIMARY KEY (film_id))]
liquibase.exception.CommandExecutionException: liquibase.exception.LiquibaseException: Unexpected error running Liquibase: Migration failed for change set changelog.xml::1642327687659-33::mikalsande (generated):
     Reason: liquibase.exception.DatabaseException: ERROR: type "mpaa_rating" does not exist
  Position: 356 [Failed SQL: (0) CREATE TABLE public.film (film_id INTEGER GENERATED BY DEFAULT AS IDENTITY NOT NULL, title VARCHAR(255) NOT NULL, description TEXT, release_year YEAR, language_id SMALLINT NOT NULL, rental_duration SMALLINT DEFAULT 3 NOT NULL, rental_rate numeric(4, 2) DEFAULT 4.99 NOT NULL, length SMALLINT, replacement_cost numeric(5, 2) DEFAULT 19.99 NOT NULL, rating MPAA_RATING DEFAULT 'G', last_update TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, special_features TEXT[], fulltext TSVECTOR NOT NULL, CONSTRAINT film_pkey PRIMARY KEY (film_id))]
        at liquibase.command.CommandScope.execute(CommandScope.java:163)
        at liquibase.integration.commandline.CommandRunner.call(CommandRunner.java:45)
        at liquibase.integration.commandline.CommandRunner.call(CommandRunner.java:15)
        at picocli.CommandLine.executeUserObject(CommandLine.java:1953)
        at picocli.CommandLine.access$1300(CommandLine.java:145)
        at picocli.CommandLine$RunLast.executeUserObjectOfLastSubcommandWithSameParent(CommandLine.java:2352)
        at picocli.CommandLine$RunLast.handle(CommandLine.java:2346)
        at picocli.CommandLine$RunLast.handle(CommandLine.java:2311)
        at picocli.CommandLine$AbstractParseResultHandler.execute(CommandLine.java:2179)
        at picocli.CommandLine.execute(CommandLine.java:2078)
        at liquibase.integration.commandline.LiquibaseCommandLine.lambda$execute$1(LiquibaseCommandLine.java:325)
        at liquibase.Scope.child(Scope.java:189)
        at liquibase.Scope.child(Scope.java:165)
        at liquibase.integration.commandline.LiquibaseCommandLine.execute(LiquibaseCommandLine.java:291)
        at liquibase.integration.commandline.LiquibaseCommandLine.main(LiquibaseCommandLine.java:80)
Caused by: liquibase.exception.LiquibaseException: Unexpected error running Liquibase: Migration failed for change set changelog.xml::1642327687659-33::mikalsande (generated):
```

Missing SQL:
```
CREATE TYPE public.mpaa_rating AS ENUM (
    'G',
    'PG',
    'PG-13',
    'R',
    'NC-17'
);
```

Missing XML:
```
    <changeSet author="manual" id="1642327687659-32.2">
        <sqlFile dbms="all" encoding="utf8" endDelimiter=";" path="domain-mpaa_rating.sql" relativeToChangelogFile="true" splitStatements="true" stripComments="true"/>
    </changeSet>
```


### Third error

Error:
```
[2022-01-16 12:06:37] SEVERE [liquibase.integration] ERROR: function group_concat(text) does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 199 [Failed SQL: (0) CREATE VIEW public.film_list AS SELECT film.film_id AS fid,
    film.title,
    film.description,
    category.name AS category,
    film.rental_rate AS price,
    film.length,
    film.rating,
    group_concat((((actor.first_name)::text || ' '::text) || (actor.last_name)::text)) AS actors
   FROM ((((category
     LEFT JOIN film_category ON ((category.category_id = film_category.category_id)))
     LEFT JOIN film ON ((film_category.film_id = film.film_id)))
     JOIN film_actor ON ((film.film_id = film_actor.film_id)))
     JOIN actor ON ((film_actor.actor_id = actor.actor_id)))
  GROUP BY film.film_id, film.title, film.description, category.name, film.rental_rate, film.length, film.rating;]
liquibase.exception.CommandExecutionException: liquibase.exception.LiquibaseException: Unexpected error running Liquibase: Migration failed for change set changelog.xml::1642327687659-34::mikalsande (generated):
     Reason: liquibase.exception.DatabaseException: ERROR: function group_concat(text) does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 199 [Failed SQL: (0) CREATE VIEW public.film_list AS SELECT film.film_id AS fid,
    film.title,
    film.description,
    category.name AS category,
    film.rental_rate AS price,
    film.length,
    film.rating,
    group_concat((((actor.first_name)::text || ' '::text) || (actor.last_name)::text)) AS actors
   FROM ((((category
     LEFT JOIN film_category ON ((category.category_id = film_category.category_id)))
     LEFT JOIN film ON ((film_category.film_id = film.film_id)))
     JOIN film_actor ON ((film.film_id = film_actor.film_id)))
     JOIN actor ON ((film_actor.actor_id = actor.actor_id)))
  GROUP BY film.film_id, film.title, film.description, category.name, film.rental_rate, film.length, film.rating;]
        at liquibase.command.CommandScope.execute(CommandScope.java:163)
        at liquibase.integration.commandline.CommandRunner.call(CommandRunner.java:45)
        at liquibase.integration.commandline.CommandRunner.call(CommandRunner.java:15)
        at picocli.CommandLine.executeUserObject(CommandLine.java:1953)
        at picocli.CommandLine.access$1300(CommandLine.java:145)
        at picocli.CommandLine$RunLast.executeUserObjectOfLastSubcommandWithSameParent(CommandLine.java:2352)
        at picocli.CommandLine$RunLast.handle(CommandLine.java:2346)
        at picocli.CommandLine$RunLast.handle(CommandLine.java:2311)
        at picocli.CommandLine$AbstractParseResultHandler.execute(CommandLine.java:2179)
        at picocli.CommandLine.execute(CommandLine.java:2078)
        at liquibase.integration.commandline.LiquibaseCommandLine.lambda$execute$1(LiquibaseCommandLine.java:325)
        at liquibase.Scope.child(Scope.java:189)
        at liquibase.Scope.child(Scope.java:165)
        at liquibase.integration.commandline.LiquibaseCommandLine.execute(LiquibaseCommandLine.java:291)
        at liquibase.integration.commandline.LiquibaseCommandLine.main(LiquibaseCommandLine.java:80)
```

Missing SQL
```
CREATE FUNCTION public._group_concat(text, text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT CASE
  WHEN $2 IS NULL THEN $1
  WHEN $1 IS NULL THEN $2
  ELSE $1 || ', ' || $2
END
$_$;
```

Missing XML
```
    <changeSet author="manual" id="1642327687659-33.1">
        <sqlFile dbms="all" encoding="utf8" endDelimiter=";" path="function-group_concat.sql" relativeToChangelogFile="true" splitStatements="true" stripComments="true"/>
    </changeSet>
```