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

  describe '#calculate_total_cost' do
    let(:sailing1) do
      instance_double(
        Sailing,
        rate: BigDecimal('100.00'),
        rate_currency: 'EUR',
        departure_date: Date.new(2022, 1, 29),
      )
    end

    let(:sailing2) do
      instance_double(
        Sailing,
        rate: BigDecimal('100.00'),
        rate_currency: 'USD',
        departure_date: Date.new(2022, 1, 29),
      )
    end

    before do
      allow(sailing2.departure_date).to receive(:strftime).with('%Y-%m-%d').and_return('2022-01-29')
    end

    it 'sums converted costs of all sailings' do
      expected = BigDecimal('100.00') + (BigDecimal('100.00') * 0.85)
      expect(calculator.calculate_total_cost([sailing1, sailing2])).to eq(expected)
    end
  end
end
