class ForecastController < ApplicationController
  include AccuweatherForecast

  def index
    @city = params[:city]
    @response = @city ? forecast(@city) : forecast_default
  end
end
