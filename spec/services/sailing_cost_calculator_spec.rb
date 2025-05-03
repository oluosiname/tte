# frozen_string_literal: true

RSpec.describe SailingCostCalculator do
  subject(:calculator) { described_class.new(exchange_rates) }

  let(:exchange_rates) do
    instance_double(ExchangeRates, rate_for: 0.85)
  end

  describe '#calculate_cost' do
    let(:sailing) do
      instance_double(
        Sailing,
        rate: 100.0,
        rate_currency: currency,
        departure_date: Date.new(2024, 2, 1),
      )
    end

    context 'when currency is EUR' do
      let(:currency) { 'EUR' }

      it 'returns the original rate' do
        expect(calculator.calculate_cost(sailing)).to eq(100.0)
      end
    end

    context 'when currency is USD' do
      let(:currency) { 'USD' }

      it 'converts to EUR using exchange rate' do
        expect(calculator.calculate_cost(sailing)).to eq(85.0)
      end
    end
  end
end
