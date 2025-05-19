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
    find_all_routes(origin, destination)
  end

  private

  def find_all_routes(origin, destination, visited = Set.new)
    routes = []

    # Add direct sailings
    routes += direct_sailings(origin, destination).map { |sailing| [sailing] }

    # Find next possible ports
    next_sailings = sailings_from(origin)

    next_sailings.each do |first_sailing|
      next_port = first_sailing.destination_port
      next if visited.include?(next_port)

      new_visited = visited + [origin]
      sub_routes = find_all_routes(next_port, destination, new_visited)

      sub_routes.each do |sub_route|
        if valid_connection?(first_sailing, sub_route.first)
          routes << [first_sailing] + sub_route
        end
      end
    end

    routes
  end

  def sailings_from(origin)
    @sailings.select { |sailing| sailing.origin_port == origin }
  end

  def sailings_to(destination)
    @sailings.select { |sailing| sailing.destination_port == destination }
  end

  def valid_connection?(first, second)
    first.destination_port == second.origin_port &&
      first.arrival_date < second.departure_date
  end
end
