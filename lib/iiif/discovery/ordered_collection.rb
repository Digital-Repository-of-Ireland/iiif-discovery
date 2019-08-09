module IIIF
  module Discovery
    class OrderedCollection < AbstractResource

      TYPE = %w(OrderedCollection)

      def required_keys
        super + %w{ id type last }
      end

      def array_only_keys
        super + %w{ see_also }
      end

      def int_only_keys
        %w{ total_items }
      end

      def type_only_keys
        {
          'part_of' => IIIF::Discovery::PartOf,
          'first' => IIIF::Discovery::Page,
          'last' => IIIF::Discovery::Page,
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

        unless part_of.nil? || part_of.empty?
          unless part_of.kind_of?(Array)
            m = "part_of must be an Array"
            raise IIIF::Discovery::IllegalValueError, m
          end

          part_of.each do | part |
            valid, message = Validate.part_of(part)
            raise IIIF::Discovery::IllegalValueError, message unless valid
          end
        end
      end

    end
  end
end
