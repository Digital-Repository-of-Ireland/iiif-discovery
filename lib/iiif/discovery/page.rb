module IIIF
  module Discovery
    class Page < AbstractResource

      def required_keys
        super + %w{ id type }
      end

      def initialize(hsh={})
        hsh['type'] = 'OrderedCollectionPage'
        super(hsh)
      end

      def validate
        super

        unless self.id.nil? || self.id.empty?
          valid, m = Validate.id(self.id)
          raise IIIF::Discovery::IllegalValueError, m unless valid
          raise IIIF::Discovery::IllegalValueError, 'type must be OrderedCollectionPage' unless self['type'] == 'OrderedCollectionPage'
        end
      end

      def to_ordered_hash(opts={})
        opts[:include_context] = false
        super(opts)
      end

    end
  end
end
