describe IIIF::Discovery::SeeAlso do

  let(:fixed_values) do
  {
    "id" => "https://example.org/dataset/single-item.jsonld",
    "type" => "Dataset",
  }
  end

  describe '#initialize' do
    it 'sets type' do
      expect(subject['type']).to eq 'Dataset'
    end
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

  context 'validation' do

    let(:see_also) { IIIF::Discovery::Service.parse(fixed_values) }

    it "must have an id" do
      see_also.delete('id')
      expect{ see_also.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "id must be a string" do
      expect{ see_also.id = nil }.to raise_error IIIF::Discovery::IllegalValueError
    end

    it "id must be an HTTP(S) URI" do
      see_also.id = 'test'
      expect{ see_also.validate }.to raise_error IIIF::Discovery::IllegalValueError
    end

    it "id must be an HTTP(S) URI" do
      see_also.id = 'https://example.com'
      expect{ see_also.validate }.not_to raise_error
    end

    it "must have type" do
      see_also.delete('type')
      expect{ see_also.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "type must Dataset" do
      see_also['type'] = 'test'
      expect{ see_also.validate }.to raise_error IIIF::Discovery::IllegalValueError
    end
  end
end
