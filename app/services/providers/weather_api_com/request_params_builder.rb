# frozen_string_literal: true

module Providers
  module WeatherApiCom
    class RequestParamsBuilder
      def call(location_name)
        {
          method: :get,
          url: build_url(location_name),
          headers: build_headers,
          timeout: request_timeout
        }
      end

      private

      def build_url(location_name)
        "#{url}?key=#{api_key}&q=#{location_name}"
      end

      def build_headers
        { "Content-Type": "application/json" }
      end

      def url
        Rails.application.credentials.dig(:weather_api_providers, :weather_api_com, :url)
      end

      def api_key
        Rails.application.credentials.dig(:weather_api_providers, :weather_api_com, :api_key)
      end

      def request_timeout
        3.seconds
      end
    end
  end
end
