# frozen_string_literal: true

class CheapestDirectStrategy
  def initialize(sailings, calculator)
    @sailings = sailings
    @calculator = calculator
  end

  def find(origin, destination)
    return [] if sailings.empty?

    [sailings.min_by { |sailing| @calculator.calculate_cost(sailing) }]
  end

  private

  attr_reader :sailings, :calculator
end
