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
    result[city] = request_forecast(city.downcase)
    result
  end

  # Return 5 days forecast for default cities.
  def forecast_default
    cities_forecast = {}
    DEFAULT_CITIES.each do |city|
      cities_forecast[city] = request_forecast(city.downcase)
    end
    cities_forecast
  end

  private

  def request_forecast(city)
    response = Redis.current.get(city)
    if response.nil?
      location_key = location_key(city)
      unless location_key.nil?
        # Get 5 days forecast
        url = FORECAST_URL % { location_key: location_key,
                               api_key: ENV['ACID_FORECAST_ACCUWEATHER_KEY'] }
        response = HTTParty.get(url).parsed_response.to_json
        cache_response(city, response)
      end
    end
    response ||= '{}'
    JSON.parse(response)
  end

  def cache_response(key, response)
    Redis.current.set(key, response)
    Redis.current.expire(key, CACHE_EXPIRE_TIME)
  end

  # Get city location key
  def location_key(city)
    search_url = SEARCH_URL % { city: city,
                                api_key: ENV['ACID_FORECAST_ACCUWEATHER_KEY'] }
    response = HTTParty.get(search_url).parsed_response
    !response.empty? ? response[0]['Key'] : nil
  end
end
