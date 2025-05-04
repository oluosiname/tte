# frozen_string_literal: true

class FileParser
  def initialize(filename)
    @filename = filename
  end

  def read_input
    validate_file_exists!
    lines = File.readlines(@filename, chomp: true)
    validate_line_count!(lines)

    origin, destination, criteria = lines
    validate_input!(origin, destination, criteria)

    [origin, destination, criteria]
  end

  private

  def validate_file_exists!
    raise ArgumentError, "Input file not found: #{@filename}" unless File.exist?(@filename)
  end

  def validate_line_count!(lines)
    raise ArgumentError, 'File must contain exactly 3 lines' unless lines.size == 3
  end

  def validate_input!(origin, destination, criteria)
    raise ArgumentError, 'Invalid origin port' unless valid_port?(origin)
    raise ArgumentError, 'Invalid destination port' unless valid_port?(destination)
    raise ArgumentError, 'Invalid criteria' unless valid_criteria?(criteria)
  end

  def valid_port?(port)
    port.match?(/^[A-Z]{5}$/)
  end

  def valid_criteria?(criteria)
    ['cheapest-direct', 'cheapest'].include?(criteria)
  end
end
