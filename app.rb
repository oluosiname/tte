# frozen_string_literal: true

require 'json'
require 'date'

require_relative 'lib/services/sailing_data'
require_relative 'lib/runner'

json_data = File.read(File.join(__dir__, 'data/response.json'))
Runner.run(json_data)
