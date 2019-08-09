module IIIF
  module Discovery
    class SeeAlso < AbstractResource

      TYPE = %w(Dataset)

      def required_keys
        super + %w{ id type }
      end

      def string_only_keys
        super + %w{ format }
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
