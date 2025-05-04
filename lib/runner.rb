# frozen_string_literal: true

require_relative 'console'
require_relative 'services/sailing_service'
require_relative 'services/sailing_data'
require_relative 'file_parser'
require 'optparse'

class Runner
  class << self
    def run(json_data)
      options = parse_options
      console = Console.new
      sailing_data = SailingData.new(json_data)
      service = SailingService.new(sailing_data)

      begin
        input = read_input(options)
        result = service.find_routes(*input)
        console.write_output(result)
      rescue ArgumentError => e
        console.write_output({ error: e.message }.to_json)
      end
    end

    private

    def parse_options
      options = { mode: :interactive }

      OptionParser.new do |opts|
        opts.banner = 'Usage: docker-compose run route-calculator [options]'

        opts.on('-i', '--interactive', 'Interactive mode (default)') do
          options[:mode] = :interactive
        end

        opts.on('-f FILENAME', '--file FILENAME', 'Read input from file') do |filename|
          options[:mode] = :file
          options[:filename] = filename
        end
      end.parse!

      options
    end

    def read_input(options)
      case options[:mode]
      when :file
        FileParser.new(options[:filename]).read_input
      else
        Console.new.read_input
      end
    end
  end
end
