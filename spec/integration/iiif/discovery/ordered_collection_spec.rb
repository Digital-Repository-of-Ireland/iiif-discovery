describe IIIF::Discovery::OrderedCollection do

  describe 'self#from_ordered_hash' do
    let(:fixtures_dir) { File.join(File.dirname(__FILE__), '../../../fixtures') }
    let(:manifest_from_spec_path) { File.join(fixtures_dir, 'manifests/ordered_collection.json') }
    let(:fixture) { JSON.parse(IO.read(manifest_from_spec_path)) }

    it 'doesn\'t raise a NoMethodError when we check the keys' do
      expect { described_class.from_ordered_hash(fixture) }.to_not raise_error
    end
    it 'turns the fixture into an OrderedCollection instance' do
      expected_klass = described_class
      parsed = described_class.from_ordered_hash(fixture)
      expect(parsed.class).to be expected_klass
    end
    it 'turns page keys into Page instance' do
      expected_klass = IIIF::Discovery::Page
      parsed = described_class.from_ordered_hash(fixture)
      expect(parsed['first'].class).to be expected_klass
      expect(parsed['first'].id).to eq 'https://example.org/activity/page-0'

      expect(parsed['last'].class).to be expected_klass
      expect(parsed['last'].id).to eq 'https://example.org/activity/page-214'
    end
    it 'turns part_of into PartOf instance' do
      expected_klass = IIIF::Discovery::PartOf
      parsed = described_class.from_ordered_hash(fixture)
      expect(parsed['part_of'].first.class).to be expected_klass
      expect(parsed['part_of'].first.id).to eq 'https://example.org/aggregated-changes'
    end
    it 'turns see_also into SeeAlso instance' do
      expected_klass = IIIF::Discovery::SeeAlso
      parsed = described_class.from_ordered_hash(fixture)
      expect(parsed['see_also'].first.class).to be expected_klass
      expect(parsed['see_also'].first.id).to eq 'https://example.org/dataset/all-dcat.jsonld'
    end
  end
end
