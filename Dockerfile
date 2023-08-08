ARG BASE_IMAGE_TAG=latest

FROM postgis/postgis:$BASE_IMAGE_TAG as base-image

ENV ORACLE_HOME /usr/lib/oracle/client
ENV PATH $PATH:${ORACLE_HOME}




FROM base-image as basic-deps

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl



FROM basic-deps as common-deps

# /var/lib/apt/lists/ still has the indexes from parent stage, so there's no need to run apt-get update again.
# (unless the parent stage cache is not invalidated...)
RUN apt-get install -y --no-install-recommends \
	gcc \
	make \
	postgresql-server-dev-$PG_MAJOR





FROM common-deps as build-pgvector

WORKDIR /tmp
ARG REPO=https://github.com/pgvector/pgvector.git
RUN apt-get install -y --no-install-recommends git && \
	git clone $REPO --single-branch --branch $(git ls-remote --tags --refs $REPO | tail -n1 | cut -d/ -f3)
WORKDIR /tmp/pgvector
RUN make clean && \
		make OPTFLAGS="" && \
		make install

FROM base-image as final-stage

# libaio1 is a runtime requirement for the Oracle client that oracle_fdw uses
# libsqlite3-mod-spatialite is a runtime requirement for using spatialite with sqlite_fdw
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		libaio1 \
		postgresql-$PG_MAJOR-semver \
		postgresql-$PG_MAJOR-similarity \
		postgresql-$PG_MAJOR-unit \
	apt-get purge -y --auto-remove && \
	rm -rf /var/lib/apt/lists/*

COPY --from=build-pgvector \
	/usr/share/postgresql/$PG_MAJOR/extension/vector* \
	/usr/share/postgresql/$PG_MAJOR/extension/
COPY --from=build-pgvector \
	/usr/lib/postgresql/$PG_MAJOR/lib/vector* \
	/usr/lib/postgresql/$PG_MAJOR/lib/

RUN echo ${ORACLE_HOME} > /etc/ld.so.conf.d/oracle_instantclient.conf && \
	ldconfig

COPY ./conf.sh  /docker-entrypoint-initdb.d/z_conf.sh
