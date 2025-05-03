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
end
