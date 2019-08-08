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

  describe "#{described_class}.define_methods_for_hash_only_keys" do
    it_behaves_like 'it has the appropriate methods for hash-only keys'
  end

  describe "#{described_class}.define_methods_for_any_type_keys" do
    it_behaves_like 'it has the appropriate methods for any-type keys'
  end
end
