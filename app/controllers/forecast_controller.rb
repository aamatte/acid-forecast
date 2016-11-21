class ForecastController < ApplicationController
  include AccuweatherForecast

  def index
    @response = forecast_default
  end
end
