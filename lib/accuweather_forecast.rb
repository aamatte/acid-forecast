require 'rubygems'

# Accuweather Forecast API wrapper
module AccuweatherForecast
  # When no city is provided, these cities forecasts are shown.
  DEFAULT_CITIES = ['Paris', 'Bangkok', 'Santiago', 'New York', 'Bamako'].freeze
  # Weather doesn't change so frequently, so let's cache it :)
  CACHE_EXPIRE_TIME = 60 * 10 # 10 minutes

  FORECAST_URL = 'http://dataservice.accuweather.com/forecasts/v1/daily/5day/'\
                  '%{location_key}?apikey=%{api_key}&metric=true'.freeze

  SEARCH_URL = 'http://dataservice.accuweather.com/locations/v1/search'\
               '?q=%{city}&apikey=%{api_key}&metric=true'.freeze

  # Return 5 days forecast for a city.
  def forecast(city)
    result = {}
    result[city] = request_forecast(city)
    result
  end

  # Return 5 days forecast for default cities.
  def forecast_default
    cities_forecast = {}
    DEFAULT_CITIES.each do |city|
      cities_forecast[city] = request_forecast(city)
    end
    cities_forecast
  end

  private

  def request_forecast(city)
    search_url = SEARCH_URL % { city: city,
                                api_key: ENV['ACID_FORECAST_ACCUWEATHER_KEY'] }
    response = Redis.current.get(search_url)
    if response.nil?
      # Get city location key
      location_key = HTTParty.get(search_url).parsed_response[0]['Key']

      # Get 5 days forecast
      url = FORECAST_URL % { location_key: location_key,
                             api_key: ENV['ACID_FORECAST_ACCUWEATHER_KEY'] }
      response = HTTParty.get(url).parsed_response.to_json

      cache_response(search_url, response)
    end
    JSON.parse(response)
  end

  def cache_response(key, response)
    Redis.current.set(key, response)
    Redis.current.expire(key, CACHE_EXPIRE_TIME)
  end
end
