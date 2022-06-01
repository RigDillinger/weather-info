# frozen_string_literal: true

require "rails_helper"

RSpec.describe Providers::WeatherApiCom::Provider do
  subject(:service) do
    described_class.new(response_parser, request_params_builder, request_sender)
  end

  let(:response_parser) { instance_double(Providers::WeatherApiCom::Parser) }
  let(:request_params_builder) { instance_double(Providers::WeatherApiCom::RequestParamsBuilder) }
  let(:request_sender) { instance_double(::RequestSender) }

  describe "#call" do
    let(:location_name) { "Moscow" }
    let(:request_params) { { some: :request_params } }
    let(:data) { { "response" => "data" } }
    let(:json) { data.to_json }
    let(:parsed_data) { instance_double(Entities::Forecast) }
    let(:result) { service.call(location_name) }

    before do
      allow(request_params_builder).to receive(:call).with(location_name).and_return(request_params)
      allow(request_sender).to receive(:call).with(request_params).and_return(json)
      allow(JSON).to receive(:parse).with(json).and_return(data)
      allow(response_parser).to receive(:call).with(data).and_return(parsed_data)
    end

    it "calls dependencies", :aggregate_failures do
      expect(request_params_builder).to receive(:call).with(location_name)
      expect(request_sender).to receive(:call).with(request_params)
      expect(response_parser).to receive(:call).with(data)

      result
    end

    it "parses JSON response body" do
      expect(JSON).to receive(:parse).with(json)

      result
    end

    it "returns parsed response" do
      expect(result).to eq(parsed_data)
    end
  end
end
