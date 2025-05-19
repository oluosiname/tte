# frozen_string_literal: true

require_relative '../dtos/sailing_dto'

class SailingData
  attr_reader :sailings, :exchange_rates

  def initialize(json_data)
    @json_data = json_data
    @sailings = build_sailings
    @exchange_rates = build_exchange_rates
  end

  private

  attr_reader :json_data

  def parsed_json_data
    @parsed_json_data ||= JSON.parse(json_data, symbolize_names: true)
  end

  def build_exchange_rates
    parsed_json_data[:exchange_rates].transform_keys(&:to_s)
  end

  def build_sailings
    SailingDTO.new(
      parsed_json_data[:sailings],
      parsed_json_data[:rates],
    ).sailings
  end
end
