# frozen_string_literal: true

class SailingCostCalculator
  def initialize(exchange_rates)
    @exchange_rates = exchange_rates
  end

  def calculate_cost(sailing)
    return sailing.rate if sailing.rate_currency == 'EUR'

    exchange_rate = @exchange_rates.rate_for(
      sailing.rate_currency.downcase,
      sailing.departure_date.to_date.strftime('%Y-%m-%d'),
    )

    sailing.rate * exchange_rate
  end
end
