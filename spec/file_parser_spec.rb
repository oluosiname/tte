# frozen_string_literal: true

RSpec.describe FileParser do
  subject(:parser) { described_class.new(temp_file.path) }

  let(:temp_file) { Tempfile.new(['input', '.txt']) }

  after { temp_file.unlink }

  describe '#read_input' do
    context 'with valid input' do
      before do
        temp_file.write("CNSHA\nNLRTM\ncheapest-direct")
        temp_file.close
      end

      it 'returns array of three values' do
        expect(parser.read_input).to eq(['CNSHA', 'NLRTM', 'cheapest-direct'])
      end
    end

    context 'with invalid file' do
      it 'raises error when file does not exist' do
        parser = described_class.new('nonexistent.txt')
        expect { parser.read_input }.to raise_error(ArgumentError, /Input file not found/)
      end
    end

    context 'with wrong number of lines' do
      before do
        temp_file.write("CNSHA\nNLRTM")
        temp_file.close
      end

      it 'raises error' do
        expect { parser.read_input }.to raise_error(ArgumentError, /must contain exactly 3 lines/)
      end
    end

    context 'with invalid port codes' do
      before do
        temp_file.write("invalid\nNLRTM\ncheapest-direct")
        temp_file.close
      end

      it 'raises error for invalid origin' do
        expect { parser.read_input }.to raise_error(ArgumentError, /Invalid origin port/)
      end
    end

    context 'with invalid criteria' do
      before do
        temp_file.write("CNSHA\nNLRTM\ninvalid")
        temp_file.close
      end

      it 'raises error' do
        expect { parser.read_input }.to raise_error(ArgumentError, /Invalid criteria/)
      end
    end
  end
end
