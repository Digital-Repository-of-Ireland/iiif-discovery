module IIIF
  module Discovery
    class OrderedCollectionPage < AbstractResource

      TYPE = %w(OrderedCollectionPage)

      def required_keys
        super + %w{ id type ordered_items }
      end

      def string_only_keys
        super + %w{ id }
      end

      def array_only_keys
        super + %w{ ordered_items }
      end

      def hash_only_keys
        super + %w{ part_of next prev }
      end

      def int_only_keys
        %w{ start_index }
      end

      def plain_hash_keys
        %w{ part_of next prev }
      end

      def initialize(hsh={})
        hsh['type'] = TYPE.first unless hsh.has_key? 'type'
        super(hsh)
      end

      def validate
        super
      end

    end
  end
end
