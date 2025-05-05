# frozen_string_literal: true

class FastestSailingStrategy
  def initialize(sailings, calculator)
    @sailings = sailings
    @calculator = calculator
  end

  def find(origin, destination)
    return [] if @sailings.empty?

    find_fastest_sailing(@sailings)
  end

  private

  def find_fastest_sailing(sailings)
    sailings.min_by { |sailing_legs| calculate_total_duration(sailing_legs) }
  end

  def calculate_total_duration(sailing_legs)
    first_sailing = sailing_legs.first
    last_sailing = sailing_legs.last

    last_sailing.arrival_date - first_sailing.departure_date
  end
end
