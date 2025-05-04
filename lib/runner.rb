# frozen_string_literal: true

require_relative 'console'
require_relative 'services/sailing_service'
require_relative 'services/sailing_data'

class Runner
  class << self
    def run(json_data)
      console = Console.new
      sailing_data = SailingData.new(json_data)
      service = SailingService.new(sailing_data)

      begin
        origin, destination, criteria = console.read_input

        result = service.find_routes(origin, destination, criteria)

        console.write_output(result)
      rescue ArgumentError => e
        console.write_output({ error: e.message }.to_json)
      end
    end
  end
end
