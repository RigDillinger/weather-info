# frozen_string_literal: true

class WeatherInfoFetcher
  def call(location_name, provider_code:)
    provider = select_provider(provider_code)
    provider.call(location_name)
  rescue Exceptions::FetchDataFailed, Exceptions::UnknownProvider => exception
    log_error(exception.message)
    exception.message
  end

  private

  attr_reader :request_params_builder

  def select_provider(code)
    provider_class = "Providers::#{code.camelize}::Provider".constantize
    provider_class.new
  rescue NameError => exception
    raise Exceptions::UnknownProvider, "Unknown provider"
  end

  def log_error(message)
    Rails.logger.error(message)
  end
end
