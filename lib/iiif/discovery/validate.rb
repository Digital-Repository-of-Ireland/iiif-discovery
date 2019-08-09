module IIIF
  module Discovery
    module Validate

      def Validate.id(id)
        if id =~ /\A#{URI::regexp(['http', 'https'])}\z/
          true
        else
          false
        end
      end

      def Validate.part_of(part_of)
        reqd = %w(id type) - part_of.keys.map(&:to_s)
        unless reqd.empty?
          m = "#{reqd.join(',')} required for each part_of"
          return false, m
        end

        true
      end

    end
  end
end
