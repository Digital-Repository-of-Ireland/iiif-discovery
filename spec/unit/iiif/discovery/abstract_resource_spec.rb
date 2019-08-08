require 'active_support/inflector'
require 'json'
require 'iiif/presentation'

describe IIIF::Discovery::AbstractResource do

  let(:fixtures_dir) { File.join(File.dirname(__FILE__), '../../../fixtures') }
  let(:manifest_from_spec_path) { File.join(fixtures_dir, 'manifests/ordered_collection.json') }
  let(:abstract_resource_subclass) do
    Class.new(IIIF::Discovery::AbstractResource) do
      include IIIF::HashBehaviours

      def initialize(hsh={})
        hsh['type'] = 'a:SubClass' unless hsh.has_key?('type')
        super(hsh)
      end

      def required_keys
        super + %w{ id }
      end
    end
  end

  subject do
    instance = abstract_resource_subclass.new
    instance['id'] = 'http://example.com/prefix/activity/123'
    instance
  end

  describe '#initialize' do
    it 'raises an error if you try to instantiate AbstractResource' do
      expect { IIIF::Discovery::AbstractResource.new }.to raise_error(RuntimeError)
    end
    it 'sets type' do
      expect(subject['type']).to eq 'a:SubClass'
    end
    it 'can take any old hash' do
      hsh = JSON.parse(IO.read(manifest_from_spec_path))
      new_instance = abstract_resource_subclass.new(hsh)
      expect(new_instance['total_items']).to eq 21456
    end
  end

  describe '#required_keys' do
    it 'accumulates' do
      expect(subject.required_keys).to eq %w{ type id }
    end
  end

  describe '#to_ordered_hash' do
    describe 'adds the @context' do
      before(:each) { subject.delete('@context') }
      it 'by default' do
        expect(subject.has_key?('@context')).to be_falsey
        expect(subject.to_ordered_hash.has_key?('@context')).to be_truthy
      end
      it 'unless you say not to' do
        expect(subject.has_key?('@context')).to be_falsey
        expect(subject.to_ordered_hash(include_context: false).has_key?('@context')).to be_falsey
      end
      it 'or it\'s already there' do
        different_ctxt = 'http://example.org/context'
        subject['@context'] = different_ctxt
        oh = subject.to_ordered_hash
        expect(oh['@context']).to eq different_ctxt
      end
    end

    describe 'runs the validations' do
      # Test this here because there's nothing to validate on the superclass (Subject)
      let(:error) { IIIF::Discovery::MissingRequiredKeyError }
      before(:each) { subject.delete('id') }
      it 'raises exceptions' do
        expect { subject.to_ordered_hash }.to raise_error error
      end
      it 'unless you tell it not to' do
        expect { subject.to_ordered_hash(force: true) }.to_not raise_error
      end
    end
  end

end

