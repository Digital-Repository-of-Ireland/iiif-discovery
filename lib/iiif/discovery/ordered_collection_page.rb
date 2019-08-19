module IIIF
  module Discovery
    class OrderedCollectionPage < AbstractResource

      TYPE = %w(OrderedCollectionPage)

      def required_keys
        super + %w{ id type ordered_items }
      end

      def array_only_keys
        super + %w{ ordered_items }
      end

      def int_only_keys
        %w{ start_index }
      end

      def type_only_keys
        {
          'ordered_items' => IIIF::Discovery::Activity,
          'part_of' => IIIF::Discovery::PartOf,
          'next' => IIIF::Discovery::Page,
          'prev' => IIIF::Discovery::Page
        }
      end

      def initialize(hsh={})
        hsh['type'] = TYPE.first unless hsh.has_key? 'type'
        super(hsh)
      end

      def validate
        super

        unless Validate.id(id)
          m = "id must be an HTTP(S) URL"
          raise IIIF::Discovery::IllegalValueError, m
        end
      end

    end
  end
end
