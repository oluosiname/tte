# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SailingFilter do
  subject(:filter) { described_class.new(sailings) }

  let(:sailing_cnsha_nlrtm) do
    instance_double(
      Sailing,
      origin_port: 'CNSHA',
      destination_port: 'NLRTM',
      departure_date: Date.new(2022, 1, 29),
      arrival_date: Date.new(2022, 2, 15),
    )
  end

  let(:sailing_cnsha_esbcn) do
    instance_double(
      Sailing,
      origin_port: 'CNSHA',
      destination_port: 'ESBCN',
      departure_date: Date.new(2022, 1, 29),
      arrival_date: Date.new(2022, 2, 6),
    )
  end

  let(:sailing_esbcn_nlrtm) do
    instance_double(
      Sailing,
      origin_port: 'ESBCN',
      destination_port: 'NLRTM',
      departure_date: Date.new(2022, 2, 7),
      arrival_date: Date.new(2022, 2, 12),
    )
  end

  let(:shanghai_barcelona) do
    instance_double(
      Sailing,
      origin_port: 'CNSHA',
      destination_port: 'ESBCN',
      departure_date: Date.new(2022, 1, 29),
      arrival_date: Date.new(2022, 2, 6),
    )
  end

  let(:barcelona_rotterdam) do
    instance_double(
      Sailing,
      origin_port: 'ESBCN',
      destination_port: 'NLRTM',
      departure_date: Date.new(2022, 2, 16),
      arrival_date: Date.new(2022, 2, 20),
    )
  end

  let(:shanghai_santos) do
    instance_double(
      Sailing,
      origin_port: 'CNSHA',
      destination_port: 'BRSSZ',
      departure_date: Date.new(2022, 1, 29),
      arrival_date: Date.new(2022, 2, 6),
    )
  end

  let(:barcelona_santos) do
    instance_double(
      Sailing,
      origin_port: 'ESBCN',
      destination_port: 'BRSSZ',
      departure_date: Date.new(2022, 1, 29),
      arrival_date: Date.new(2022, 2, 6),
    )
  end

  let(:sailings) do
    [
      sailing_cnsha_nlrtm,
      sailing_cnsha_esbcn,
      sailing_esbcn_nlrtm,
      shanghai_barcelona,
      barcelona_rotterdam,
      shanghai_santos,
      barcelona_santos,
    ]
  end

  describe '#direct_sailings' do
    context 'when direct sailings exist' do
      it 'returns sailings matching origin and destination' do
        result = filter.direct_sailings('CNSHA', 'NLRTM')
        expect(result).to eq([sailing_cnsha_nlrtm])
      end
    end

    context 'when no direct sailings exist' do
      it 'returns empty array' do
        result = filter.direct_sailings('NLRTM', 'CNSHA')
        expect(result).to be_empty
      end
    end

    context 'when there are multiple matches' do
      let(:sailing4) do
        instance_double(
          Sailing,
          origin_port: 'CNSHA',
          destination_port: 'NLRTM',
        )
      end
      let(:sailings) do
        [sailing_cnsha_nlrtm, sailing_cnsha_esbcn, sailing_esbcn_nlrtm, sailing_cnsha_nlrtm]
      end

      it 'returns all matching sailings' do
        result = filter.direct_sailings('CNSHA', 'NLRTM')
        expect(result).to eq([sailing_cnsha_nlrtm, sailing_cnsha_nlrtm])
      end
    end

    context 'when there are no sailings' do
      let(:sailings) { [] }

      it 'returns empty array' do
        result = filter.direct_sailings('CNSHA', 'NLRTM')
        expect(result).to be_empty
      end
    end
  end

  describe '#all_possible_sailings' do
    context 'with direct and indirect sailings' do
      let(:shanghai_barcelona) do
        instance_double(
          Sailing,
          origin_port: 'CNSHA',
          destination_port: 'ESBCN',
          departure_date: Date.new(2022, 1, 29),
          arrival_date: Date.new(2022, 2, 6),
        )
      end

      let(:barcelona_rotterdam) do
        instance_double(
          Sailing,
          origin_port: 'ESBCN',
          destination_port: 'NLRTM',
          departure_date: Date.new(2022, 2, 7),
          arrival_date: Date.new(2022, 2, 12),
        )
      end

      let(:barcelona_santos) do
        instance_double(
          Sailing,
          origin_port: 'ESBCN',
          destination_port: 'BRSSZ',
          departure_date: Date.new(2022, 2, 13),
          arrival_date: Date.new(2022, 2, 20),
        )
      end

      let(:santos_rotterdam) do
        instance_double(
          Sailing,
          origin_port: 'BRSSZ',
          destination_port: 'NLRTM',
          departure_date: Date.new(2022, 2, 21),
          arrival_date: Date.new(2022, 2, 28),
        )
      end

      let(:sailings) do
        [
          sailing_cnsha_nlrtm, # Direct route
          shanghai_barcelona,            # First leg of 2-leg route
          barcelona_rotterdam,           # Second leg of 2-leg route
          barcelona_santos,              # Middle leg of 3-leg route
          santos_rotterdam, # Final leg of 3-leg route
        ]
      end

      it 'includes direct sailings' do
        result = filter.all_possible_sailings('CNSHA', 'NLRTM')
        expect(result).to include([sailing_cnsha_nlrtm])
      end

      it 'includes two-leg sailings' do
        result = filter.all_possible_sailings('CNSHA', 'NLRTM')
        expect(result).to include([shanghai_barcelona, barcelona_rotterdam])
      end

      it 'includes three-leg sailings' do
        result = filter.all_possible_sailings('CNSHA', 'NLRTM')
        expect(result).to include([shanghai_barcelona, barcelona_santos, santos_rotterdam])
      end

      it 'validates sailing dates between legs' do
        invalid_connection = instance_double(
          Sailing,
          origin_port: 'ESBCN',
          destination_port: 'NLRTM',
          departure_date: Date.new(2022, 2, 1), # Before first leg arrives
          arrival_date: Date.new(2022, 2, 5),
        )
        sailings << invalid_connection

        result = filter.all_possible_sailings('CNSHA', 'NLRTM')
        expect(result).not_to include([shanghai_barcelona, invalid_connection])
      end
    end

    context 'with potential cycles' do
      let(:rotterdam_barcelona) do
        instance_double(
          Sailing,
          origin_port: 'NLRTM',
          destination_port: 'ESBCN',
          departure_date: Date.new(2022, 2, 13),
          arrival_date: Date.new(2022, 2, 20),
        )
      end

      let(:sailings) do
        [
          shanghai_barcelona,
          barcelona_rotterdam,
          rotterdam_barcelona, # Could create a cycle
        ]
      end

      it 'avoids cycles in routes' do
        result = filter.all_possible_sailings('CNSHA', 'NLRTM')
        expect(result).not_to include([
          shanghai_barcelona,
          barcelona_rotterdam,
          rotterdam_barcelona,
          barcelona_rotterdam,
        ])
      end
    end

    context 'with no possible sailings' do
      let(:sailings) { [] }

      it 'returns empty array' do
        result = filter.all_possible_sailings('CNSHA', 'NLRTM')
        expect(result).to be_empty
      end
    end
  end
end
