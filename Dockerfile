FROM elixir:1.12.2-alpine as builder

RUN apk upgrade
RUN apk update
RUN apk add --update openssl bash libstdc++ git build-base gcc alpine-sdk

RUN mkdir /app
COPY . /app
WORKDIR /app

ENV MIX_ENV=prod

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.repo && \
    mix deps.get && \
    mix release --overwrite

FROM alpine:3.13.5

RUN apk add --update openssl bash libstdc++

RUN apk upgrade

EXPOSE 4000/tcp

WORKDIR /app/api
COPY --from=builder /app/_build/prod/ /app/api/
