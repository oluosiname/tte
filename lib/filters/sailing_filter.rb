# frozen_string_literal: true

class SailingFilter
  def initialize(sailings)
    @sailings = sailings
  end

  def direct_sailings(origin, destination)
    @sailings.select do |sailing|
      sailing.origin_port == origin &&
        sailing.destination_port == destination
    end
  end

  def all_possible_sailings(origin, destination)
    direct = direct_sailings(origin, destination)
    connecting = connecting_sailings(origin, destination)

    direct.map { |sailing| [sailing] } + connecting
  end

  private

  def connecting_sailings(origin, destination)
    sailings_from_origin = sailings_from(origin)
    sailings_to_dest = sailings_to(destination)

    # Find ports that appear as both destination of first leg and origin of second leg
    intermediate_ports = sailings_from_origin.map(&:destination_port) &
      sailings_to_dest.map(&:origin_port)

    intermediate_ports.flat_map do |port|
      first_leg = direct_sailings(origin, port)
      second_leg = direct_sailings(port, destination)

      combine_valid_sailings(first_leg, second_leg)
    end
  end

  def sailings_from(origin)
    @sailings.select { |sailing| sailing.origin_port == origin }
  end

  def sailings_to(destination)
    @sailings.select { |sailing| sailing.destination_port == destination }
  end

  def combine_valid_sailings(first_leg, second_leg)
    first_leg.product(second_leg).select do |first, second|
      valid_connection?(first, second)
    end
  end

  def valid_connection?(first, second)
    first.destination_port == second.origin_port &&
      first.arrival_date < second.departure_date
  end
end
