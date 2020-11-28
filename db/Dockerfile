FROM postgres:13.1-alpine
#
# libpq in postgresql-contrib is used by the DBI::Pg module 
RUN apk update
RUN apk add postgresql-contrib
COPY initdb.d/*.sh /docker-entrypoint-initdb.d/
CMD [ "postgres" ]

