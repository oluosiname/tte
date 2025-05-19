# frozen_string_literal: true

RSpec.describe CheapestSailingStrategy do
  subject(:strategy) { described_class.new(sailings, calculator) }

  let(:calculator) { instance_double(SailingCostCalculator) }

  let(:direct_sailing) do
    instance_double(
      Sailing,
      origin_port: 'CNSHA',
      destination_port: 'NLRTM',
      departure_date: Date.new(2022, 1, 29),
      arrival_date: Date.new(2022, 2, 15),
    )
  end

  let(:first_leg) do
    instance_double(
      Sailing,
      origin_port: 'CNSHA',
      destination_port: 'ESBCN',
      departure_date: Date.new(2022, 1, 29),
      arrival_date: Date.new(2022, 2, 6),
    )
  end

  let(:second_leg) do
    instance_double(
      Sailing,
      origin_port: 'ESBCN',
      destination_port: 'NLRTM',
      departure_date: Date.new(2022, 2, 16),
      arrival_date: Date.new(2022, 2, 20),
    )
  end

  let(:sailings) { [[direct_sailing], [first_leg, second_leg]] }

  describe '#find' do
    before do
      allow(calculator).to receive(:calculate_total_cost).with([direct_sailing]).and_return(500)
      allow(calculator).to receive(:calculate_total_cost).with([
        first_leg,
        second_leg,
      ]).and_return(400)
    end

    it 'returns the cheapest sailing option' do
      result = strategy.find('CNSHA', 'NLRTM')
      expect(result).to eq([first_leg, second_leg])
    end
  end
end
