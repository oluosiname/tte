# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ExchangeRates do
  let(:rates_data) do
    {
      '2024-02-01' => {
        usd: 0.85,
        gbp: 1.15,
      },
    }
  end

  let(:exchange_rates) { described_class.new(rates_data) }

  describe '#rate_for' do
    it 'returns correct rate for date and currency' do
      expect(exchange_rates.rate_for('usd', '2024-02-01')).to eq(0.85)
    end

    it 'raises error when rate not found' do
      expect do
        exchange_rates.rate_for('jpy', '2024-02-01')
      end.to raise_error(ArgumentError, /No exchange rate found/)
    end

    it 'raises error when date not found' do
      expect do
        exchange_rates.rate_for('usd', '2024-02-02')
      end.to raise_error(ArgumentError, /No exchange rate found/)
    end
  end
end
