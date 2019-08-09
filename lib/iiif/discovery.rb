%w{
validate
abstract_resource
  ordered_collection
    see_also
    part_of
    page
  ordered_collection_page
    activity
      actor
      object
}.each do |f|
  require File.join(File.dirname(__FILE__), 'discovery', f)
end

require 'iiif/presentation'

module IIIF
  module Discovery
    CONTEXT ||= 'http://iiif.io/api/discovery/0/context.json'

    class MissingRequiredKeyError < StandardError; end
    class IllegalValueError < StandardError; end
  end
end

# ordered_collection_page
#     ordered_item
#       activity
#         object
