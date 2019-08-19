describe IIIF::Discovery::OrderedCollectionPage do

  let(:fixed_values) do
    {
      "@context" => "http://iiif.io/api/discovery/0/context.json",
      "id" => "https://example.org/activity/page-0",
      "type" => "OrderedCollectionPage",
      "startIndex" => "20",
      "next" =>  { "id": "https://example.org/activity/page-1",
                    "type": "OrderedCollectionPage" },
      "orderedItems" =>  [ ]
    }
  end


  describe '#initialize' do
    it 'sets type' do
      expect(subject['type']).to eq 'OrderedCollectionPage'
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

    let(:ordered_collection_page) { IIIF::Discovery::Service.parse(fixed_values) }

    it "must have an id" do
      ordered_collection_page.delete('id')
      expect{ ordered_collection_page.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "id must be a string" do
      expect{ ordered_collection_page.id = nil }.to raise_error IIIF::Discovery::IllegalValueError
    end

    it "id must be an HTTP(S) URI" do
      ordered_collection_page.id = 'test'
      expect{ ordered_collection_page.validate }.to raise_error IIIF::Discovery::IllegalValueError
    end

    it "id must be an HTTP(S) URI" do
      ordered_collection_page.id = 'https://example.com'
      expect{ ordered_collection_page.validate }.not_to raise_error
    end

    it "must have type" do
      ordered_collection_page.delete('type')
      expect{ ordered_collection_page.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "must have ordered items" do
      ordered_collection_page.delete('ordered_items')
      expect{ ordered_collection_page.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "requires ordered_items to be an array" do
      expect{ ordered_collection_page.ordered_items = 'items' }.to raise_error IIIF::Discovery::IllegalValueError
      expect{ ordered_collection_page.ordered_items = [IIIF::Discovery::Activity.new] }.not_to raise_error
    end
  end
end
