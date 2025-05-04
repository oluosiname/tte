# frozen_string_literal: true

require_relative '../strategies/cheapest_direct_strategy'
require_relative '../strategies/cheapest_sailing_strategy'
require_relative '../services/sailing_cost_calculator'
require_relative '../services/exchange_rates'
require_relative '../filters/sailing_filter'

class SailingService
  STRATEGIES = {
    'cheapest-direct' => CheapestDirectStrategy,
    'cheapest' => CheapestSailingStrategy,
  }.freeze

  def initialize(repository)
    @repository = repository
    @calculator = SailingCostCalculator.new(ExchangeRates.new(repository.exchange_rates))
    @filter = SailingFilter.new(repository.sailings)
  end

  def find_routes(origin, destination, criteria)
    strategy_class = STRATEGIES.fetch(criteria) do
      raise ArgumentError, "Unknown criteria: #{criteria}"
    end

    filtered_sailings = valid_sailings(origin, destination, criteria)
    strategy = strategy_class.new(filtered_sailings, @calculator)
    sailings = strategy.find(origin, destination)

    format_sailings(sailings)
  end

  private

  def valid_sailings(origin, destination, criteria)
    case criteria
    when 'cheapest-direct'
      @filter.direct_sailings(origin, destination)
    when 'cheapest'
      @filter.all_possible_sailings(origin, destination)
    end
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
