class ForecastController < ApplicationController
  def index
    @city = city_params[:city]
    @response = @city ? AccuweatherClient.forecast(@city) : AccuweatherClient.forecast_default
  end

  private

  def city_params
    params.permit(:city)
  end
end
