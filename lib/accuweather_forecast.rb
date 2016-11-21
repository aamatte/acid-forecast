require 'rubygems'

module AccuweatherForecast
  DEFAULT_CITIES = ['Paris', 'Bangkok', 'Santiago', 'New York', 'Bamako'].freeze

  FORECAST_URL = 'http://dataservice.accuweather.com/forecasts/v1/daily/5day/'\
                  '%{location_key}?apikey=%{api_key}'.freeze

  SEARCH_URL = 'http://dataservice.accuweather.com/locations/v1/search'\
               '?q=%{city}&apikey=%{api_key}'.freeze

  # Return 5 days forecast for a city.
  def forecast(city)
    # Get city location key
    url = SEARCH_URL % { city: city, api_key: '7ZosCieAvQ5DQDifozMAD42pc2F3Aq96' } # TODO: change to ENV
    location_key = HTTParty.get(url).parsed_response[0]['Key']

    # Get 5 days forecast
    url = FORECAST_URL % { location_key: location_key, api_key: '7ZosCieAvQ5DQDifozMAD42pc2F3Aq96' }
    HTTParty.get(url).parsed_response
  end

  # Return 5 days forecast for the default cities.
  def forecast_default
    cities_forecast = {}
    DEFAULT_CITIES.each do |city|
      cities_forecast[city] = forecast(city)
    end
    cities_forecast
  end
end
