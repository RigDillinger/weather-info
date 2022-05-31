# frozen_string_literal: true

class RequestSender
  def call(request_params)
    retries_count ||= 0
    make_request(request_params)
  rescue RestClient::Exceptions::OpenTimeout => exception
    handle_error(exception, :connection_open_timeout)
  rescue RestClient::Exceptions::ReadTimeout => exception
    retries_count += 1
    retry if retries_count < MAX_RETRIES_COUNT
    handle_error(exception, :connection_read_timeout)
  rescue RestClient::ExceptionWithResponse => exception
    handle_error(exception, parse_exception(exception))
  end

  private

  MAX_RETRIES_COUNT = 3

  private_constant :MAX_RETRIES_COUNT

  def make_request(params)
    RestClient::Request.execute(params)
  end

  def handle_error(exception, error_code)
    raise Exceptions::FetchDataFailed, error_code
  end

  def parse_exception(exception)
    parsed_error = JSON.parse(exception.response.body)
    parsed_error.dig("error", "message")
  end
end
