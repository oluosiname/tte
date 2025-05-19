# frozen_string_literal: true

require 'bigdecimal'
class Sailing
  attr_reader :origin_port,
    :destination_port,
    :departure_date,
    :arrival_date,
    :sailing_code,
    :rate,
    :rate_currency

  def initialize(attributes)
    @origin_port = attributes[:origin_port]
    @destination_port = attributes[:destination_port]
    @departure_date = Date.parse(attributes[:departure_date]) if attributes[:departure_date]
    @arrival_date = Date.parse(attributes[:arrival_date]) if attributes[:arrival_date]
    @sailing_code = attributes[:sailing_code]
    @rate = BigDecimal(attributes[:rate]) if attributes[:rate]
    @rate_currency = attributes[:rate_currency]
  end
end
