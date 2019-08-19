module IIIF
  module Discovery
    class Actor < AbstractResource

      TYPE = %w(Application Organisation Person)

      def required_keys
        super + %w{ id type }
      end

      def string_only_keys
        super + %w{ type format }
      end

      def initialize(hsh={})
        hsh['type'] = TYPE.first unless hsh.key? 'type'
        super(hsh)
      end

      def validate
        super

        valid, m = Validate.id(self.id)
        raise IIIF::Discovery::IllegalValueError, m unless valid

        raise IIIF::Discovery::IllegalValueError, "type must be one of #{TYPE.join(', ')}" unless TYPE.include?(self.type)
      end

      def to_ordered_hash(opts={})
        opts[:include_context] = false
        super(opts)
      end

    end
  end
end
