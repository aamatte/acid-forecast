class ForecastController < ApplicationController
  include AccuweatherForecast

  def index
    @city = city_params[:city]
    @response = @city ? forecast(@city) : forecast_default
  end

  private

  def city_params
    params.permit(:city)
  end
end
