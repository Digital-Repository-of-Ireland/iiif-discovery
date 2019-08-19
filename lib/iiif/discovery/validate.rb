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
    end
  end
end
