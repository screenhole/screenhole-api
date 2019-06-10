# Screenhole API

> **Documentation:** https://screenhole.docs.apiary.io

Screenhole's API is a fairly bog-standard Rails application. It's deployed to Heroku with a pipeline-based setup.

## tl;dr

- `bundle install`
- `rails db:setup`
- `rails server`

## Prerequisites

- Ruby 2.6.1
  - Run `brew install rbenv ruby-build`
  - Run `rbenv install 2.6.1`
- Postgres
  - Install [Postgres.app](https://postgresapp.com/)
- Redis
  - Run `brew install redis`
  - Run `sudo brew services start redis`
- Bundler
  - Run `gem install bundler`

## Getting Started

1. Clone this repository
1. Install dependencies via `bundle install`
1. Create databases via `rails db:create`
1. Run migrations via `rails db:migrate`

### Web Server

1. Run `rails server`

### Tests

1. Lint via `rubocop`
1. Test via `rspec`
