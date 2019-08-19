describe IIIF::Discovery::OrderedCollection do

  let(:fixed_values) do
    {
      "@context" => "http://iiif.io/api/discovery/0/context.json",
      "id" => "https://example.org/activity/all-changes",
      "type" => "OrderedCollection",
      "totalItems" => "21456",
      "last" =>  { "id": "https://example.org/activity/page-0",
                    "type": "OrderedCollectionPage" },
      "otherContent" =>  [ ]
    }
  end


  describe '#initialize' do
    it 'sets type' do
      expect(subject['type']).to eq 'OrderedCollection'
    end
  end

  describe "#{described_class}.int_only_keys" do
    it_behaves_like 'it has the appropriate methods for integer-only keys'
  end

  describe "#{described_class}.define_methods_for_string_only_keys" do
    it_behaves_like 'it has the appropriate methods for string-only keys'
  end

  describe "#{described_class}.define_methods_for_array_only_keys" do
    it_behaves_like 'it has the appropriate methods for array-only keys'
  end

  describe "#{described_class}.define_methods_for_type_only_keys" do
    it_behaves_like 'it has the appropriate methods for type-only keys'
  end

  context 'validation' do

    let(:ordered_collection) { IIIF::Discovery::Service.parse(fixed_values) }

    it "must have an id" do
      ordered_collection.delete('id')
      expect{ ordered_collection.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "id must be a string" do
      expect{ ordered_collection.id = nil }.to raise_error IIIF::Discovery::IllegalValueError
    end

    it "id must be an HTTP(S) URI" do
      ordered_collection.id = 'test'
      expect{ ordered_collection.validate }.to raise_error IIIF::Discovery::IllegalValueError
    end

    it "id must be an HTTP(S) URI" do
      ordered_collection.id = 'https://example.com'
      expect{ ordered_collection.validate }.not_to raise_error
    end

    it "must have type" do
      ordered_collection.delete('type')
      expect{ ordered_collection.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "must have last" do
      ordered_collection.delete('last')
      expect{ ordered_collection.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "requires part_of to be an array PartOf" do
      expect{ ordered_collection.part_of = 'part_of' }.to raise_error IIIF::Discovery::IllegalValueError
      expect{ ordered_collection.part_of = [IIIF::Discovery::PartOf.new] }.not_to raise_error
    end

    it "requires see also to be an array of SeeAlso" do
      expect{ ordered_collection.see_also = 'see_also' }.to raise_error IIIF::Discovery::IllegalValueError
      expect{ ordered_collection.see_also = [IIIF::Discovery::SeeAlso.new] }.not_to raise_error
    end
  end
end
