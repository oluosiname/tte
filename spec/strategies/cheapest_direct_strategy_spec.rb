# frozen_string_literal: true

RSpec.describe CheapestDirectStrategy do
  subject(:strategy) { described_class.new(sailings, calculator) }

  let(:calculator) { instance_double(SailingCostCalculator) }
  let(:sailing_with_lowest_cost) do
    instance_double(
      Sailing,
      origin_port: 'CNSHA',
      destination_port: 'NLRTM',
      rate: 100,
      rate_currency: 'EUR',
    )
  end
  let(:sailing_with_higher_cost) do
    instance_double(
      Sailing,
      origin_port: 'CNSHA',
      destination_port: 'NLRTM',
      rate: 200,
      rate_currency: 'EUR',
    )
  end
  let(:sailings) { [sailing_with_lowest_cost, sailing_with_higher_cost] }

  describe '#find' do
    before do
      allow(calculator).to receive(:calculate_cost).with(sailing_with_lowest_cost).and_return(85)
      allow(calculator).to receive(:calculate_cost).with(sailing_with_higher_cost).and_return(170)
    end

    it 'returns the cheapest direct sailing' do
      result = strategy.find('CNSHA', 'NLRTM')
      expect(result).to eq([sailing_with_lowest_cost])
    end
  end
end
