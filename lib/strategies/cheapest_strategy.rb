# frozen_string_literal: true

class CheapestStrategy
  def initialize(sailings, calculator)
    @sailings = sailings
    @calculator = calculator
  end

  def find(origin, destination)
    sailings.sort_by(&:rate).first
  end
end
