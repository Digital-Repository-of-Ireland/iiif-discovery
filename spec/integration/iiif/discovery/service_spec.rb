require 'active_support/inflector'
require 'json'

describe IIIF::Discovery::Service do

  let(:fixtures_dir) { File.join(File.dirname(__FILE__), '../../../fixtures') }
  let(:manifest_from_spec_path) { File.join(fixtures_dir, 'manifests/ordered_collection_page.json') }

  describe 'self.parse' do
    it 'works from a file' do
      s = described_class.parse(manifest_from_spec_path)
      expect(s['start_index']).to eq 20
    end
    it 'works from a string of JSON' do
      file = File.open(manifest_from_spec_path, 'rb')
      json_string = file.read
      file.close
      s = described_class.parse(json_string)
      expect(s['start_index']).to eq 20
    end
    describe 'works from a hash' do
      it 'plain old' do
        h = JSON.parse(IO.read(manifest_from_spec_path))
        s = described_class.parse(h)
        expect(s['start_index']).to eq 20
      end
      it 'IIIF::OrderedHash' do
         h = JSON.parse(IO.read(manifest_from_spec_path))
         oh = IIIF::OrderedHash[h]
         s = described_class.parse(oh)
         expect(s['start_index']).to eq 20
      end
    end
    it 'turns camels to snakes' do
      s = described_class.parse(manifest_from_spec_path)
      expect(s.keys.include?('start_index')).to be_truthy
      expect(s.keys.include?('seeIndex')).to be_falsey
    end
  end

  describe 'self#from_ordered_hash' do
    let(:fixture) { JSON.parse('{
        "@context": "http://iiif.io/api/discovery/0/context.json",
        "id": "https://example.org/activity/page-1",
        "type": "OrderedCollectionPage",
        "startIndex": 20,
        "partOf": {
          "id": "https://example.org/activity/all-changes",
          "type": "OrderedCollection"
        },
        "some_other_thing": {
          "foo" : "bar"
        },
        "prev": {
          "id": "https://example.org/activity/page-0",
          "type": "OrderedCollectionPage"
        },
        "next": {
          "id": "https://example.org/activity/page-2",
          "type": "OrderedCollectionPage"
        },
        "orderedItems": [
          {
            "type": "Update",
            "object": {
              "id": "https://example.org/iiif/1/manifest",
              "type": "Manifest"
            },
            "endTime": "2018-03-10T10:00:00Z"
          }
        ]
      }')
    }
    it 'doesn\'t raise a NoMethodError when we check the keys' do
      expect { described_class.from_ordered_hash(fixture) }.to_not raise_error
    end
    it 'turns the fixture into an OrderedCollectionPage instance' do
      expected_klass = IIIF::Discovery::OrderedCollectionPage
      parsed = described_class.from_ordered_hash(fixture)
      expect(parsed.class).to be expected_klass
    end
    it 'turns keys without "type" into an OrderedHash' do
      expected_klass = IIIF::OrderedHash
      parsed = described_class.from_ordered_hash(fixture)
      expect(parsed['some_other_thing'].class).to be expected_klass
    end
    it 'turns keys with given type into the type' do
      expected_klass = IIIF::Discovery::Page
      parsed = described_class.from_ordered_hash(fixture)
      expect(parsed['prev'].class).to be expected_klass
    end

    it 'round-trips' do
      fp = '/tmp/discovery-spec.json'
      parsed = described_class.from_ordered_hash(fixture)
      File.open(fp,'w') do |f|
        f.write(parsed.to_json)
      end
      from_file = IIIF::Discovery::Service.parse('/tmp/discovery-spec.json')
      File.delete(fp)
      # is this sufficient?
      expect(parsed.to_ordered_hash.to_a - from_file.to_ordered_hash.to_a).to eq []
      expect(from_file.to_ordered_hash.to_a - parsed.to_ordered_hash.to_a).to eq []
    end
    it 'turns each member of "orderedItems" into an instance of Activity' do
      expected_klass = IIIF::Discovery::Activity
      parsed = described_class.from_ordered_hash(fixture)
      parsed['ordered_items'].each do |s|
        expect(s.class.to_s).to eq expected_klass.to_s
      end
    end
    it 'turns member of orderedItems/object into an instance of Object' do
      expected_klass = IIIF::Discovery::Object
      parsed = described_class.from_ordered_hash(fixture)
      parsed['ordered_items'].each do |s|
        s.object do |c|
          expect(c.class.to_s).to eq expected_klass.to_s
        end
      end
    end
    it 'turns the keys into snakes' do
      expect(described_class.from_ordered_hash(fixture).has_key?('partOf')).to be_falsey
      expect(described_class.from_ordered_hash(fixture).has_key?('part_of')).to be_truthy
    end

  end
end
