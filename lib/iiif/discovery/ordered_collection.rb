module IIIF
  module Discovery
    class OrderedCollection < AbstractResource

      TYPE = %w(OrderedCollection)

      def required_keys
        super + %w{ id type }
      end

      def string_only_keys
        super + %w{ id }
      end

      def array_only_keys
        super + %w{ see_also part_of }
      end

      def hash_only_keys
        super + %w{ first last }
      end

      def plain_hash_keys
        %w{ part_of first last }
      end

      def int_only_keys
        %w{ total_items }
      end

      def initialize(hsh={})
        hsh['type'] = TYPE.first unless hsh.has_key? 'type'
        super(hsh)
      end

      def validate
        super

        unless part_of.empty?
          part_of.each do |part|
            %w(id type).each do |key|
              unless part.key?(key)
                m = "A(n) #{key} is required for each part_of"
                raise IIIF::Discovery::MissingRequiredKeyError, m
              end
            end
          end
        end
      end

    end
  end
end
