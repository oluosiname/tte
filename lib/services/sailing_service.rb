# frozen_string_literal: true

require_relative '../strategies/cheapest_direct_strategy'
require_relative '../services/sailing_cost_calculator'
require_relative '../services/exchange_rates'
require_relative '../filters/sailing_filter'

class SailingService
  def initialize(repository)
    @repository = repository
    @calculator = SailingCostCalculator.new(ExchangeRates.new(repository.exchange_rates))
    @filter = SailingFilter.new(repository.sailings)
  end

  def find_cheapest_direct(origin, destination)
    sailings = valid_sailings(origin, destination)
    strategy = CheapestDirectStrategy.new(sailings, @calculator)
    sailings = strategy.find(origin, destination)

    format_sailings(sailings)
  end

  private

  def valid_sailings(origin, destination)
    @filter.direct_sailings(origin, destination)
  end

  def format_sailings(sailings)
    sailings.map do |sailing|
      {
        origin_port: sailing.origin_port,
        destination_port: sailing.destination_port,
        departure_date: sailing.departure_date.iso8601,
        arrival_date: sailing.arrival_date.iso8601,
        sailing_code: sailing.sailing_code,
        rate: format('%.2f', sailing.rate),
        rate_currency: sailing.rate_currency,
      }
    end.to_json
  end
end
