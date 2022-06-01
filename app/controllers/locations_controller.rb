# frozen_string_literal: true

class LocationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(name: params[:name])

    if @location.save
      redirect_to @location
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @locations = Location.all
  end

  def show
    @location = find_location
    @weather_info = fetch_weather_info(@location.name)
  end

  def destroy
    @location = find_location
    @location.destroy

    redirect_to locations_path, status: :see_other
  end

  private

  DEFAULT_PROVIDER_CODE = "weather_api_com"

  private_constant :DEFAULT_PROVIDER_CODE

  def find_location
    Location.find(params[:id])
  end

  def fetch_weather_info(location_name)
    weather_info_fetcher.call(location_name, provider_code: params[:provider] || DEFAULT_PROVIDER_CODE)
  end

  def weather_info_fetcher
    ::WeatherInfoFetcher.new
  end
end
