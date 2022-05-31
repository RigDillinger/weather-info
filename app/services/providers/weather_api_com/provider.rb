# frozen_string_literal: true

module Providers
  module WeatherApiCom
    class Provider
      def initialize(
        response_parser = default_response_parser,
        request_params_builder = default_request_params_builder,
        request_sender = default_request_sender
      )
        @response_parser = response_parser
        @request_params_builder = request_params_builder
        @request_sender = request_sender
      end

      def call(location_name)
        request_params = build_request_params(location_name)
        data = execute_request(request_params)
        parse_data(data)
      end

      private

      attr_reader :response_parser, :request_params_builder, :request_sender

      def build_request_params(location_name)
        request_params_builder.call(location_name)
      end

      def execute_request(request_params)
        response = request_sender.call(request_params)

        JSON.parse(response)
      end

      def parse_data(data)
        response_parser.call(data)
      end

      def default_response_parser
        Providers::WeatherApiCom::Parser.new
      end

      def default_request_params_builder
        Providers::WeatherApiCom::RequestParamsBuilder.new
      end

      def default_request_sender
        ::RequestSender.new
      end
    end
  end
end
