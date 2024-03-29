module IIIF
  module Discovery
    class Activity < AbstractResource

      TYPE = %w(Update Create Delete)

      def required_keys
        super + %w{ type object }
      end

      def any_type_keys
        super + %w{ object }
      end

      def string_only_keys
        super + %w{ type end_time start_time summary }
      end

      def array_only_keys
        super + %w{ ordered_items }
      end

      def initialize(hsh={})
        hsh['type'] = TYPE.first unless hsh.has_key? 'type'
        super(hsh)
      end

      def validate
        super

        unless self.id.nil? || self.id.empty?
          valid, m = Validate.id(self.id)
          raise(IIIF::Discovery::IllegalValueError, m) unless valid
        end
      end

      def to_ordered_hash(opts={})
        opts[:include_context] = false
        super(opts)
      end

    end
  end
end
