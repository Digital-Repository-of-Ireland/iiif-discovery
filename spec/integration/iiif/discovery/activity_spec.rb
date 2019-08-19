describe IIIF::Discovery::Activity do

  describe 'self#from_ordered_hash' do
    let(:fixtures_dir) { File.join(File.dirname(__FILE__), '../../../fixtures') }
    let(:manifest_from_spec_path) { File.join(fixtures_dir, 'manifests/activity.json') }
    let(:fixture) { JSON.parse(IO.read(manifest_from_spec_path)) }

    it 'doesn\'t raise a NoMethodError when we check the keys' do
      expect { described_class.from_ordered_hash(fixture) }.to_not raise_error
    end
    it 'turns the fixture into an Activity instance' do
      expected_klass = described_class
      parsed = described_class.from_ordered_hash(fixture)
      expect(parsed.class).to be expected_klass
    end
    it 'turns actor key into Actor instance' do
      expected_klass = IIIF::Discovery::Actor
      parsed = described_class.from_ordered_hash(fixture)
      expect(parsed['actor'].class).to be expected_klass
      expect(parsed['actor'].id).to eq 'https://example.org/person/admin1'
    end
    it 'turns object into Object instance' do
      expected_klass = IIIF::Discovery::Object
      parsed = described_class.from_ordered_hash(fixture)
      expect(parsed['object'].class).to be expected_klass
      expect(parsed['object'].id).to eq 'https://example.org/iiif/1/manifest'
      expect(parsed['object'].see_also.first.class).to be IIIF::Discovery::SeeAlso
    end
  end
end
