module Mongoid
  module Geospatial
    class Point
      def to_a
        [y, x]
      end
    end
  end
end
