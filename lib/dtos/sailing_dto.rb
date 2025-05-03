# frozen_string_literal: true

require 'json'
require_relative '../models/sailing'

class SailingDTO
  REQUIRED_KEYS = [
    :origin_port,
    :destination_port,
    :departure_date,
    :arrival_date,
    :sailing_code,
    :rate,
    :rate_currency,
  ].freeze

  attr_reader :sailings

  def initialize(sailings_data, rates_data)
    @sailings = build_sailings(sailings_data, index_rates(rates_data))
  end

  private

  def build_sailings(sailings_data, rates_by_code)
    sailings_data.map do |sailing_data|
      rate_data = rates_by_code[sailing_data[:sailing_code]]
      sailing_attributes = sailing_data.merge(rate_data)
      Sailing.new(symbolize_keys(sailing_attributes))
    end
  end

  def index_rates(rates_data)
    rates_data.each_with_object({}) do |rate, hash|
      hash[rate[:sailing_code]] = {
        'rate' => rate[:rate],
        'rate_currency' => rate[:rate_currency],
      }
    end
  end

  def symbolize_keys(hash)
    hash.transform_keys(&:to_sym)
  end
end
