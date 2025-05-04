# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SailingDTO do
  subject(:dto) { described_class.new(sailings_data, rates_data) }

  let(:sailings_data) do
    [
      {
        origin_port: 'CNSHA',
        destination_port: 'NLRTM',
        departure_date: '2022-01-29',
        arrival_date: '2022-02-15',
        sailing_code: 'QRST',
      },
    ]
  end

  let(:rates_data) do
    [
      {
        sailing_code: 'QRST',
        rate: '761.96',
        rate_currency: 'EUR',
      },
    ]
  end

  describe '#sailings' do
    it 'returns array of Sailing objects' do
      expect(dto.sailings).to all(be_a(Sailing))
    end

    it 'combines sailing and rate data' do
      sailing = dto.sailings.first
      expect(sailing.origin_port).to eq('CNSHA')
      expect(sailing.destination_port).to eq('NLRTM')
      expect(sailing.sailing_code).to eq('QRST')
      expect(sailing.rate).to eq(761.96)
      expect(sailing.rate_currency).to eq('EUR')
    end
  end
end
