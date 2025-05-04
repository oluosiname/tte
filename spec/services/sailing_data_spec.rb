# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SailingData do
  subject(:sailing_data) { described_class.new(json_data) }

  let(:json_data) do
    {
      'sailings' => [
        {
          'origin_port' => 'CNSHA',
          'destination_port' => 'NLRTM',
          'departure_date' => '2022-01-29',
          'arrival_date' => '2022-02-15',
          'sailing_code' => 'QRST',
        },
      ],
      'rates' => [
        {
          'sailing_code' => 'QRST',
          'rate' => '761.96',
          'rate_currency' => 'EUR',
        },
      ],
      'exchange_rates' => {
        '2022-01-29' => {
          'usd' => 1.1138,
          'jpy' => 130.85,
        },
      },
    }.to_json
  end

  describe '#sailings' do
    it 'returns an array of Sailing objects' do
      expect(sailing_data.sailings).to all(be_a(Sailing))
    end

    it 'correctly combines sailing and rate data' do
      sailing = sailing_data.sailings.first
      expect(sailing.origin_port).to eq('CNSHA')
      expect(sailing.destination_port).to eq('NLRTM')
      expect(sailing.sailing_code).to eq('QRST')
      expect(sailing.rate).to eq(761.96)
      expect(sailing.rate_currency).to eq('EUR')
    end
  end

  describe '#exchange_rates' do
    it 'returns the exchange rates hash' do
      expected_rates = {
        '2022-01-29' => {
          usd: 1.1138,
          jpy: 130.85,
        },
      }
      expect(sailing_data.exchange_rates).to eq(expected_rates)
    end
  end

  context 'with invalid JSON' do
    let(:json_data) { 'invalid json' }

    it 'raises JSON::ParserError' do
      expect { sailing_data }.to raise_error(JSON::ParserError)
    end
  end
end
