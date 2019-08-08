module IIIF
  module Discovery
    class Object < AbstractResource

      TYPE = %w(Manifest Collection)

      def required_keys
        super + %w{ id type }
      end

      def string_only_keys
        super + %w{ id type }
      end

      def array_only_keys
        super + %w{ see_also }
      end

      def initialize(hsh={})
        hsh['type'] = TYPE.first unless hsh.has_key? 'type'
        super(hsh)
      end

      def validate
        super
      end

      def to_ordered_hash(opts={})
        opts[:include_context] = false
        super(opts)
      end

    end
  end
end
