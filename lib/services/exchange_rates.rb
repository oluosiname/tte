# frozen_string_literal: true

class ExchangeRates
  def initialize(rates_data)
    @rates = rates_data
  end

  def rate_for(currency, date)
    @rates.dig(date, currency.to_sym) ||
      raise(ArgumentError, "No exchange rate found for #{currency} on #{date}")
  end
end
