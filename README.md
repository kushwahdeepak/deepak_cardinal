# welcome to cardinalhire jobs marketplace webapp

## Resources

- [Git](https://github.com/cardinalhire/ch-job-marketplace)
- [Heroku](https://dashboard.heroku.com/pipelines/6f662aa3-ed4a-4389-9fc7-14a9b19d0ef3)
- [Clubhouse](https://app.clubhouse.io/cardinalhire)
- [Slack](https://cardinaltalentaigroup.slack.com/)

## Dependencies

The app runs on the platform consisting of these:

    % Ruby 2.6.5
    % Rails 5.0.7
    % bundler, rvm and contents of Gemfile, obviously
    % Node.js >= 13.8.0
    % PostgreSQL >= 12.2
    # jdk 1.8
    # git
    # heroku cli

If you are not using a Mac, you may have to figure out how to install these on your system first.  The rest of instructions were only tested on a Mac.

Here are the script to install all of the dependencies on a Mac. If you're starting with a brand new computer, you may be able to just run the whole thing.  Otherwise pick the parts you're missing on your system.  

```
#install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

#get the code
brew install git
git clone https://github.com/cardinalhire/ch-job-marketplace.git
cd ch-job-marketplace

#ruby environment
\curl -sSL https://get.rvm.io | bash -s stable --rails  
source ~/.rvm/scripts/rvm
rvm install "ruby-2.6.5"
gem install bundler
bundle install

#postgres (for development db)
brew install postgres
pg_ctl -D /usr/local/var/postgres start
createuser -s example
rake db:create
rake db:schema:load
rake db:migrate

#node (for webpack)
brew install node
yarn install

#java (for development solr)
brew install java
brew tap adoptopenjdk/openjdk
brew cask install adoptopenjdk/openjdk/adoptopenjdk8
rake sunspot:solr:start
open http://localhost:8982/solr/#/  #open solr admin console

# Redis and Sideqiq
brew install redis
redis-server /usr/local/etc/redis.conf       # This will run a redis server
bundle exec sidekiq                          # This will run sidekiq

#get a copy of prod db 
scripts/copy_prod_db_to_local.sh

# done installing dependencies
# now, get a .env file from a peer on the team.  Put it in the root of the project.  It's not checked in for security reasons.
rails s
open http://localhost:3000

#heroku tools (useful for devops)
brew tap heroku/brew && brew install heroku
brew tap thoughtbot/formulae; brew install parity
heroku git:remote -r staging -a ch-job-marketplace-stage  
heroku git:remote -r production -a ch-job-marketplace-prod

#sign in/up lookups
bundle exec rake lookups:update
```

## Testing

##### Ruby test part
```shell
rspec
open coverage/index.html # To see test coverage report
```

##### React test part
```
yarn test:react - run all unit and integration tests
yarn test:react:watch - run watch mode for react tests
yarn test:react:coverage - check the detailed information and coverage
```

##### Security

```
bundle-audit
brakeman
```

## Operation
Once the app is running at http://localhost:3000, you'll need to login as an admin.  To do so, authenticate with a google 
account.  Eventually, you'll get to a screen that says sometheing like "please wait to be approved by admin."  At which 
point, opent up the console with `rails c`. Inside the console change the role of the account you just created to 
"admin" by `User.where(email:'<----your email----->')[0].update_attribute(:role,'admin')`.

Use `staging deploy` to publish your current branch to staging.

## Setup instructions for ubuntu
  
```
## Setup ruby, webpacker, node and yarn dependencies
sudo apt install curl
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

## setup ruby using RVM
sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.6.5
rvm use 2.6.5 --default

## install ruby bundler
gem install bundler

## Git setup
git config --global color.ui true
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR@EMAIL.com"
ssh-keygen -t rsa -b 4096 -C "YOUR@EMAIL.com"

## Rails setup
gem install rails -v 5.0.7.2

## Postgres setup
sudo apt install postgresql libpq-dev
sudo -u postgres createuser username -s
sudo -u postgres psql
postgres=# \password username

## Java setup
sudo rm -r /usr/lib/jvm/ ## first remove current java instalation
sudo apt-get install default-jdk -y
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt update
sudo apt install adoptopenjdk-8-openj9
rake sunspot:solr:start

```

## Getting Started

After you have downloaded and unzipped this repository, run this setup script to
set up your machine with the necessary dependencies to run and test this app:

    % ./bin/setup

## Deploying

If you have previously run the `./bin/setup` script, you can deploy to staging
and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production

We currently use the following buildpacks:

- heroku/nodejs
- heroku/ruby
- https://github.com/febeling/webpack-rails-buildpack.git

Please be sure to configure these buildpacks in the same sequence
presented here in both staging and production, or else the deploy will
not work.

## Environment

Setting environment variables on development machines or continuous integration
servers is accomplished by loading variables from a .env file into ENV when the
environment is bootstrapped.

Settings in config/environments/* take precedence over those specified here in
the repository.

By default, load will look for a file called `.env` in the project root
directory. Place environment variables that are unique to your machine (e.g.
  database user and password) in a file called `.env.development`, which will
  take precedence over the default (fake) values.

Git should ignore the `.env` file by default. (See `.gitignore`.)

Do not commit `.env` to the repository.
