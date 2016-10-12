FROM ruby:2.2-alpine
RUN apk add --no-cache git build-base
COPY . /code

WORKDIR /code
RUN bundle install
