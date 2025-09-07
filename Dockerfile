# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.4.5
FROM ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /app

# Install system deps
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      libvips \
      libyaml-dev \
      curl \
      postgresql-client \
      nodejs \
      npm && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy source
COPY . .

# Dev environment
ENV RAILS_ENV=development

# Expose Rails default port
EXPOSE 3000

# Run server by default
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
