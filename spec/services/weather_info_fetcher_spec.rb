# frozen_string_literal: true

require "rails_helper"

RSpec.describe WeatherInfoFetcher do
  subject(:service) { described_class.new }

  describe "#call" do
    let(:location_name) { "London" }
    let(:weather_api_com_provider) { instance_double(Providers::WeatherApiCom::Provider) }
    let(:provider_response) { { some: :response } }

    let(:result) { service.call(location_name, provider_code: provider_code) }

    before do
      allow(Providers::WeatherApiCom::Provider).to receive(:new).and_return(weather_api_com_provider)
      allow(weather_api_com_provider).to receive(:call).with(location_name).and_return(provider_response)
    end

    context "when provider code is valid" do
      let(:provider_code) { "weather_api_com" }

      it "builds a provider instance" do
        expect(Providers::WeatherApiCom::Provider).to receive(:new)

        result
      end

      it "calls a provider instance with a location name" do
        expect(weather_api_com_provider).to receive(:call).with(location_name)

        result
      end
    end

    context "when provider code is invalid" do
      let(:provider_code) { "some_inexistent_provider_code" }
      let(:default_logger) { instance_double(ActiveSupport::Logger) }

      before { allow(Rails).to receive(:logger).and_return(default_logger) }

      it "raises exception and logs it" do
        expect(Rails).to receive(:logger)
        expect(default_logger).to receive(:error).with("Unknown provider")

        result
      end
    end
  end
end
