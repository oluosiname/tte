# frozen_string_literal: true

RSpec.describe Runner do
  let(:json_data) do
    {
      'sailings': [
        {
          'origin_port': 'CNSHA',
          'destination_port': 'NLRTM',
          'departure_date': '2022-02-01',
          'arrival_date': '2022-03-01',
          'sailing_code': 'ABCD',
        },
        {
          'origin_port': 'CNSHA',
          'destination_port': 'ESBCN',
          'departure_date': '2022-01-29',
          'arrival_date': '2022-02-12',
          'sailing_code': 'EFGH',
        },
        {
          'origin_port': 'ESBCN',
          'destination_port': 'NLRTM',
          'departure_date': '2022-02-15',
          'arrival_date': '2022-02-20',
          'sailing_code': 'IJKL',
        },
      ],
      'rates': [
        {
          'sailing_code': 'ABCD',
          'rate': '500.00',
          'rate_currency': 'USD',
        },
        {
          'sailing_code': 'EFGH',
          'rate': '200.00',
          'rate_currency': 'EUR',
        },
        {
          'sailing_code': 'IJKL',
          'rate': '300.00',
          'rate_currency': 'USD',
        },
      ],
      'exchange_rates': {
        '2022-01-29': {
          'usd': 1.1138,
        },
        '2022-02-01': {
          'usd': 1.1260,
        },
        '2022-02-15': {
          'usd': 1.1483,
        },
      },
    }.to_json
  end

  let(:console) { instance_double(Console) }
  let(:service) { instance_double(SailingService) }

  before do
    allow(Console).to receive(:new).and_return(console)
    allow(SailingService).to receive(:new).and_return(service)
  end

  describe '#run' do
    context 'with interactive mode' do
      before do
        stub_const('ARGV', [])
        allow(console).to receive(:read_input).and_return(['CNSHA', 'NLRTM', 'cheapest-direct'])
        allow(console).to receive(:write_output)
        allow(service).to receive(:find_routes)
      end

      it 'uses console input' do
        described_class.run(json_data)
        expect(console).to have_received(:read_input)
      end
    end

    context 'with file input' do
      let(:temp_file) { Tempfile.new(['input', '.txt']) }

      before do
        temp_file.write("CNSHA\nNLRTM\ncheapest-direct\n")
        temp_file.close
        stub_const('ARGV', ['-f', temp_file.path])
        allow(console).to receive(:write_output)
        allow(service).to receive(:find_routes)
      end

      after { temp_file.unlink }

      it 'reads from file' do
        described_class.run(json_data)
        expect(service).to have_received(:find_routes).with('CNSHA', 'NLRTM', 'cheapest-direct')
      end
    end

    context 'with invalid file' do
      before do
        stub_const('ARGV', ['-f', 'nonexistent.txt'])
        allow(console).to receive(:write_output)
      end

      it 'handles missing file' do
        described_class.run(json_data)
        expect(console).to have_received(:write_output).with({ error: 'Input file not found: nonexistent.txt' }.to_json)
      end
    end
  end
end
