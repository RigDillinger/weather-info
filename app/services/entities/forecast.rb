# frozen_string_literal: true

module Entities
  Forecast = Struct.new(
    :date,
    :max_temp,
    :min_temp,
    :avg_temp,
    :wind,
    :humidity,
    :text,
    :icon_url,
    keyword_init: true
  )
end
