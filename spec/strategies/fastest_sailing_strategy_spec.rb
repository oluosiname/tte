# frozen_string_literal: true

RSpec.describe FastestSailingStrategy do
  let(:calculator) { instance_double(SailingCostCalculator) }

  let(:direct_sailing) do
    instance_double(
      Sailing,
      departure_date: Date.new(2022, 1, 29),
      arrival_date: Date.new(2022, 2, 15),
    )  # 17 days
  end

  let(:first_leg) do
    instance_double(
      Sailing,
      departure_date: Date.new(2022, 1, 29),
      arrival_date: Date.new(2022, 2, 6),
    )
  end

  let(:second_leg) do
    instance_double(
      Sailing,
      departure_date: Date.new(2022, 2, 7),
      arrival_date: Date.new(2022, 2, 12),
    )  # 14 days total
  end

  describe '#find' do
    context 'with pre-filtered sailings' do
      subject(:strategy) { described_class.new(sailings, calculator) }

      let(:sailings) { [[direct_sailing], [first_leg, second_leg]] }

      it 'returns the fastest sailing option' do
        result = strategy.find('CNSHA', 'NLRTM')
        expect(result).to eq([first_leg, second_leg])
      end
    end

    context 'with empty sailings' do
      subject(:strategy) { described_class.new(sailings, calculator) }

      let(:sailings) { [] }

      it 'returns empty array' do
        result = strategy.find('NLRTM', 'CNSHA')
        expect(result).to be_empty
      end
    end
  end
end
