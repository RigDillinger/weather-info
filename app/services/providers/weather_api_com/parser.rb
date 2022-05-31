# frozen_string_literal: true

module Providers
  module WeatherApiCom
    class Parser
      def call(data)
        forecast_options = build_forecast_options(data)
        Entities::Forecast.new(forecast_options)
      end

      private

      def build_forecast_options(data)
        daily_forecast_object = fetch_daily_forcast_object(data)

        {
          date: daily_forecast_object.dig("date"),
          max_temp: daily_forecast_object.dig("day", "maxtemp_c"),
          min_temp: daily_forecast_object.dig("day", "mintemp_c"),
          avg_temp: daily_forecast_object.dig("day", "avgtemp_c"),
          wind: daily_forecast_object.dig("day", "maxwind_kph"),
          humidity: daily_forecast_object.dig("day", "avghumidity"),
          text: daily_forecast_object.dig("day", "condition", "text"),
          icon_url: build_icon_url(daily_forecast_object.dig("day", "condition", "icon"))
        }
      end

      def fetch_daily_forcast_object(data)
        data.dig("forecast", "forecastday").first
      end

      def build_icon_url(url)
        "https:#{url}"
      end
    end
  end
end
