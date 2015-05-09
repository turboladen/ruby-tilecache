module TileCache
  module Services
    class WMS
      FIELDS = %( bbox srs width height format layers styles )

      # @param params [Hash] Rack::Request-parsed URL params
      # @param env_uri [String] env['REQUEST_URI'] from a Rack request. A
      #   temporary patch to get all request params into Mapscript instead of
      #   relying on ruby-tilecache's OWSRequest-param-setting.
      def initialize(params, env_uri = nil)
        @params = parse_request(params)
        @env_uri = env_uri
      end

      def build_map
        bbox = Bounds.parse_string(@params[:bbox])
        layer = TileCache.layers[@params[:layers]]
        # TODO: Move into config parser
        fail LayerNotFound, "Can't find layer '#{@params[:layers]}' in configuration" unless layer

        layer.env_uri = @env_uri if @env_uri
        yield layer.map if block_given?

        tile = layer.get_tile(bbox)

        layer.render(tile)
      end

      private

      def parse_request(params)
        parsed = {}
        params.each do |k, v|
          key = k.downcase
          parsed[key.to_sym] = v if FIELDS.include?(key)
        end
        parsed
      end
    end
  end
end
