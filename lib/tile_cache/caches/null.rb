require_relative 'base'

module TileCache
  module Caches
    class Null < Base
      def get(_tile)
        false
      end

      def store(tile, data = nil)
        tile.data = data if data
      end
    end
  end
end
