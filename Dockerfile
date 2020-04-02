FROM ruby:2.4-alpine
RUN apk add --no-cache git build-base
COPY . /code

WORKDIR /code
RUN bundle install
