# frozen_string_literal: true

require 'stringio'
require_relative '../lib/console'

RSpec.describe(Console) do
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }
  let(:console) { described_class.new(input, output) }

  describe '#read_input' do
    it 'removes whitespace from input' do
      ['CNSHA', 'NLRTM', 'cheapest-direct'].each { |line| input.puts(line) }
      input.rewind

      expect(console.read_input).to eq(['CNSHA', 'NLRTM', 'cheapest-direct'])
    end

    context 'with valid input' do
      before do
        ['CNSHA', 'NLRTM', 'cheapest-direct'].each { |line| input.puts(line) }
        input.rewind
      end

      it 'returns array with three lines of input' do
        expect(console.read_input).to eq(['CNSHA', 'NLRTM', 'cheapest-direct'])
      end
    end

    context 'with invalid port code' do
      before do
        ['INVALID', 'NLRTM', 'cheapest-direct'].each { |line| input.puts(line) }
        input.rewind
      end

      it 'raises ArgumentError' do
        expect { console.read_input }.to(raise_error(ArgumentError, 'Invalid port code'))
      end
    end

    context 'with invalid criteria' do
      before do
        ['CNSHA', 'NLRTM', 'invalid'].each { |line| input.puts(line) }
        input.rewind
      end

      it 'raises ArgumentError' do
        expect { console.read_input }.to(raise_error(ArgumentError, 'Invalid criteria'))
      end
    end

    context 'with insufficient input' do
      before do
        ['CNSHA', 'NLRTM'].each { |line| input.puts(line) }
        input.rewind
      end

      it 'raises ArgumentError' do
        expect { console.read_input }.to raise_error(ArgumentError, 'Missing input lines')
      end
    end
  end

  describe '#write_output' do
    context 'with JSON output' do
      let(:result) do
        [
          {
            origin_port: 'CNSHA',
            destination_port: 'NLRTM',
            departure_date: '2024-02-01',
            arrival_date: '2024-03-01',
            sailing_code: 'XXXX',
            rate: '123.00',
            rate_currency: 'USD',
          },
        ].to_json
      end

      it 'writes to output' do
        console.write_output(result)
        expect(output.string).to(eq(result + "\n"))
      end
    end

    context 'with error message' do
      let(:error) { { error: 'Invalid input' }.to_json }

      it 'writes error to output' do
        console.write_output(error)
        expect(output.string).to(eq(error + "\n"))
      end
    end
  end
end
