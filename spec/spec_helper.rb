# frozen_string_literal: true

require 'factory_bot'
require 'faker'
require 'pry'

require_relative '../lib/models/sailing'
require_relative '../lib/dtos/sailing_dto'
require_relative '../lib/services/sailing_data'
require_relative '../lib/services/exchange_rates'
require_relative '../lib/services/sailing_service'
require_relative '../lib/strategies/cheapest_direct_strategy'
require_relative '../lib/services/sailing_cost_calculator'

require_relative '../lib/console'
require_relative '../lib/filters/sailing_filter'

RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
