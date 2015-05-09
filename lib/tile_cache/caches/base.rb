module TileCache
  module Caches
    class Base
      VALID_ATTRIBUTES = %w[debug]

      def initialize(settings)
        @root = settings[:root]
        @debug = settings[:debug]
      end
    end
  end
end
