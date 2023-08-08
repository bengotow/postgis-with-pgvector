#### PostgreSQL image based on [postgis/postgis](https://hub.docker.com/r/postgis/postgis), with the pgvector extension.

Tag labels follow the pattern `X-Y.Z`, where `X` is the *major* Postgres version (starting from version 12) and `Y.Z` is the *major.minor* Postgis version.

The `latest` tag currently corresponds to `15-3.3`.

## Usage

In order to run a basic container capable of serving a Postgres database with all extensions below available:

```bash
docker run -e POSTGRES_PASSWORD=mysecretpassword -d ivanlonel/postgis-with-extensions
```

[Here](https://github.com/ivanlonel/postgis-with-extensions/tree/master/compose_example) is a sample docker-compose stack definition, which includes a [powa-web](https://hub.docker.com/r/powateam/powa-web) container and a [pgadmin](https://hub.docker.com/r/dpage/pgadmin4) container. The Postgres container is built from a Dockerfile that extends this image by running `localedef` in order to ensure Postgres will use the locale specified in docker-compose.yml.

For more detailed instructions about how to start and control your Postgres container, see the documentation for the `postgres` image [here](https://registry.hub.docker.com/_/postgres/).

## Available extensions

- [postgis](https://github.com/postgis/postgis)
- [pgvector](https://github.com/pgvector/pgvector)
- [semver](https://github.com/theory/pg-semver)
- [pg_similarity](https://github.com/eulerto/pg_similarity)
- [unit](https://github.com/df7cb/postgresql-unit)
