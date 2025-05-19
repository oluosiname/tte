# frozen_string_literal: true

class CheapestSailingStrategy
  def initialize(sailings, calculator)
    @sailings = sailings
    @calculator = calculator
    @filter = SailingFilter.new(sailings)
  end

  def find(origin, destination)
    return [] if @sailings.empty?

    find_cheapest_sailing(@sailings)
  end

  private

  def find_cheapest_sailing(sailings)
    sailings.min_by { |sailing_legs| calculate_sailing_cost(sailing_legs) }
  end

  def calculate_sailing_cost(sailing_legs)
    @calculator.calculate_total_cost(sailing_legs)
  end
end
