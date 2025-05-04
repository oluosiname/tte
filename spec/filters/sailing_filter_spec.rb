# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SailingFilter do
  subject(:filter) { described_class.new(sailings) }

  let(:sailing_cnsha_nlrtm) do
    instance_double(
      Sailing,
      origin_port: 'CNSHA',
      destination_port: 'NLRTM',
    )
  end

  let(:sailing_cnsha_esbcn) do
    instance_double(
      Sailing,
      origin_port: 'CNSHA',
      destination_port: 'ESBCN',
    )
  end

  let(:sailing_esbcn_nlrtm) do
    instance_double(
      Sailing,
      origin_port: 'ESBCN',
      destination_port: 'NLRTM',
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
end
