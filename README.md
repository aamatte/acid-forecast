# Acid forecast

Simple Rails app that gives you the 5 days forecast for different cities based
on the [Accuweather API](https://developer.accuweather.com/).

## Prerequisites

- Ruby 2.3.0
- Rails 4.2.0
- Redis server running

## Installation

First, clone the repo.

```sh
git clone https://github.com/aamatte/acid-forecast.git
```

Second, set up the redis server url:

```sh
export REDIS_URL=your_redis_server_url
```

Then, set up the Accuweather api key:

```sh
export ACID_FORECAST_ACCUWEATHER_KEY=your_accuweather_app_api_key
```
Install the needed gems:

```sh
bundle install
```

And run the server:

```sh
rails server
```
