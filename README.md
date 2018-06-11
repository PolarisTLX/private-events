# README

# Private Events - Ruby on Rails application to practice user authentication and authorization


Check out the live version on Heroku: https://safe-earth-48418.herokuapp.com/
=======

## Getting started


* System dependencies

Ruby version: 2.3.1
Rails version: 5.2.0
Bundler version: 1.16.1


To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally run the app in a local server:

```
$ rails server
```

Open your browser at "localhost:3000".


To run the RSpec test suite, first run:

```
$ rails db:seed ENV=test
```

Then run:

```
$ rspec
```


## Authors

* **Kyle Lemon** - [jklemon17](https://github.com/jklemon17)
* **Paul Rail** - [PolarisTLX](https://github.com/PolarisTLX)
