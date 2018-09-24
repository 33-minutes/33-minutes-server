module Mongoid
  module Geospatial
    class Point
      def to_s
        Geo::Coord.new(y, x).to_s
      end
    end
  end
end
