# frozen_string_literal: true

class Console
  def initialize(input = $stdin, output = $stdout)
    @input = input
    @output = output
  end

  def read_input
    @output.print 'Enter origin port: '
    origin = @input.gets&.chomp

    @output.print 'Enter destination port: '
    destination = @input.gets&.chomp

    @output.print 'Enter criteria (cheapest-direct, cheapest, fastest): '
    criteria = @input.gets&.chomp

    validate_input!([origin, destination, criteria])
    [origin, destination, criteria]
  end

  def write_output(result)
    @output.puts result
  end

  private

  def validate_input!(lines)
    raise ArgumentError, 'Missing input lines' if lines.any?(&:nil?)
    raise ArgumentError, 'Invalid port code' unless valid_port?(lines[0]) && valid_port?(lines[1])
    raise ArgumentError, 'Invalid criteria' unless valid_criteria?(lines[2])
  end

  def valid_port?(code)
    code.match?(/^[A-Z]{5}$/)
  end

  def valid_criteria?(criteria)
    ['cheapest-direct', 'cheapest', 'fastest'].include?(criteria)
  end
end
