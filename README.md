# iiif-discovery: A Ruby API for working with IIIF Discovery Activity Streams

This is based on the [osullivan gem](https://github.com/iiif-prezi/osullivan) written by Jon Stroop.

## Installation

For Rails add this line to your application's Gemfile:

```ruby
gem 'iiif-discovery'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iiif-discovery

## Building New Objects

Usage is mostly as is described for the [osullivan gem](https://github.com/iiif-prezi/osullivan#building-new-objects).

There are classes for types in the [IIIF Discovery API Spec](https://iiif.io/api/discovery/0.3/).

```ruby
require 'iiif/discovery'

# All classes act like `ActiveSupport::OrderedHash`es, for the most part.
activity = IIIF::Discovery::Activity.new
activity.id = 'https://example.org/activity/1'
activity.end_time = '2017-09-21T00:00:00Z'
activity.type = 'Update'

object = IIIF::Discovery::Object.new
object.type = 'Manifest'
object.id = 'https://example.org/iiif/1/manifest'

# ...but there are also accessors and mutators for the properties mentioned in
# the spec
object.see_also << IIIF::Discovery::SeeAlso.new(
                     'id' => "https://example.org/dataset/single-item.jsonld",
                     'format' => "application/json"
                   )
activity.object = object

puts activity.to_json(pretty: true)
```

## Parsing Existing Objects

Use `IIIF::Discovery::Service#parse`. It will figure out what the object
should be, based on `type`, and fall back to `IIIF::OrderedHash` when
it either can't, or the type does not exist e.g.:

```ruby
seed = '{
  "@context": "http://iiif.io/api/discovery/0/context.json",
  "id": "https://example.org/activity/all-changes",
  "type": "OrderedCollection",
  "totalItems": 21456,
  "seeAlso": [
    {
      "id": "https://example.org/dataset/all-dcat.jsonld",
      "type": "Dataset",
      "format": "application/ld+json"
    }
  ],
  "partOf": [
    {
      "id": "https://example.org/aggregated-changes",
      "type": "OrderedCollection"
    }
  ],
  "first": {
    "id": "https://example.org/activity/page-0",
    "type": "OrderedCollectionPage"
  },
  "last": {
    "id": "https://example.org/activity/page-214",
    "type": "OrderedCollectionPage"
  }
}'

obj = IIIF::Service.parse(seed) # can also be a file path or a Hash
puts obj.class
puts obj.first.class

> IIIF::Discovery::OrderedCollection
> IIIF::OrderedHash
```

## Validation and Exceptions

This is work in progress. Right now exceptions are generally raised when you
try to set something to a type it should never be:

```ruby
collection = IIIF::Discovery::OrderedCollection.new
collection.see_also = "example"

> [...] IIIF::Discovery::IllegalValueError (see_also must be an Array.)
```

and also if any required properties are missing when calling `to_json`

```ruby
page = IIIF::Discovery::OrderedCollectionPage.new('id' => "https://example.org/activity/page-1")
puts page.to_json(pretty: true)

> IIIF::Discovery::MissingRequiredKeyError (A(n) ordered_items is required for each IIIF::Discovery::OrderedCollectionPage)
```

but you can skip this validation by adding `force: true`:

```ruby
page = IIIF::Discovery::OrderedCollectionPage.new('id' => "https://example.org/activity/page-1")
puts page.to_json(pretty: true, force: true)
> {
>  "@context": "http://iiif.io/api/discovery/0/context.json",
>  "id": "https://example.org/activity/page-1",
>  "type": "OrderedCollectionPage"
> }
```
