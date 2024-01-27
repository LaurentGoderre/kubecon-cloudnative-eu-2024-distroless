FROM alpine as users

RUN echo 'postgres:x:70:70:Postgres:/var/lib/postgresql:/bin/false' > /passwd \
    && echo 'postgres:x:70:postgres' > /group

# -----

FROM laurentgoderre689/alpine-builder as packages

COPY packages.json /packages.json

RUN build /packages.json

# -----

FROM scratch

ENV PGDATA=/var/lib/postgresql/data
ENV PATH=/usr/local/bin/:/usr/bin/:/bin

COPY --from=users /passwd /group /etc/

COPY --from=packages /build /

COPY --from=postgres:16-alpine3.18 /usr/local/bin/ /usr/local/bin/
COPY --from=postgres:16-alpine3.18 /usr/local/lib/ /usr/local/lib/
COPY --from=postgres:16-alpine3.18 /usr/local/share/postgresql/ /usr/local/share/postgresql
COPY --from=postgres:16-alpine3.18 --chown=70:70 --chmod=777 /var/lib/postgresql /var/lib/postgresql
COPY --from=postgres:16-alpine3.18 --chown=70:70 /var/run/postgresql/ /var/run/postgresql/

VOLUME /var/lib/postgresql/data

STOPSIGNAL SIGINT

EXPOSE 5432
CMD ["postgres"]
