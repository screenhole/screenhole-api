# Screenhole API

## Installation

### Install RVM

```
\curl -L https://get.rvm.io | bash -s stable
```

Check https://rvm.io/

### Install Ruby

```
rvm install 2.6.1
rvm use 2.6.1
gem install bundler
```

### Update OS X SSL Certificates

```
rvm osx-ssl-certs update all
```

### Install Homebrew

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Check http://brew.sh/

### Install Postgresql

```
brew install postgresql
initdb /usr/local/var/postgres -E utf8
# export PGHOST=localhost # This may be necessary
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
launchctl start homebrew.mxcl.postgresql
createuser -d screenhole-api
createdb -Oscreenhole-api -Eutf8 screenhole-api_development
createdb -Oscreenhole-api -Eutf8 screenhole-api_test
```

### Install Redis

```
brew install redis
```

### Install pow

```
curl get.pow.cx | sh
```

Check http://pow.cx/ if no workie.

### Install Heroku

```
brew install heroku/brew/heroku
```

Check https://devcenter.heroku.com/articles/heroku-cli

### Install FakeS3

```
gem install fakes3
```

### Install ngrok

Visit https://ngrok.com/download, register, and authenticate.

### Install app

```
git clone git@github.com:jake/screenhole-api.git
cd screenhole-api
git remote add staging git@heroku.com:screenhole-api-staging.git
bundle
rake db:migrate
```

## Confirm Install

### Configure local hosts

```
echo 5000 > ~/.pow/screenhole
```

### Run app locally

```
heroku local
```

Go to [http://api.screenhole.dev:5000](http://api.screenhole.dev:5000).

### Run tests locally

```
rake test
```

## Configuration

### Set required environment variables

Copy `env.example` to `.env` and `config/application.yml.example` to `config/application.yml`.

### Create the default user

**Username:** jacob, **Password:** football

```
rake db:seed
```

## Deploying

### Deploy to staging

_Note:_ Staging is automatically deployed with every push to `master`. You can still force a deploy by hand.

```
git push staging master
```

View at \_\_\_

### Deploy to production

Production isn't deployed to directly. You must first deploy to staging, then promote the staging site to production using Heroku Pipelines.

```
heroku pipelines:promote
```

View at to https://api.screenhole.net
