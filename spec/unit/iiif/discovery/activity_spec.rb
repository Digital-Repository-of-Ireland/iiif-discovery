describe IIIF::Discovery::Activity do
  let(:fixed_values) do
    {
      "id" => "https://example.org/activity/1",
      "type" => "Update",
      "object" => {},
      "endTime" => "2017-09-21T00:00:00Z",
    }
    end

  describe '#initialize' do
    it 'sets type' do
      expect(subject['type']).to eq 'Update'
    end
  end

  describe "#{described_class}.define_methods_for_string_only_keys" do
    it_behaves_like 'it has the appropriate methods for string-only keys'
  end

  describe "#{described_class}.define_methods_for_array_only_keys" do
    it_behaves_like 'it has the appropriate methods for array-only keys'
  end

  describe "#{described_class}.define_methods_for_any_type_keys" do
    it_behaves_like 'it has the appropriate methods for any-type keys'
  end

  context 'validation' do

    let(:activity) { IIIF::Discovery::Service.parse(fixed_values) }

    it "id must be a string" do
      expect{ activity.id = nil }.to raise_error IIIF::Discovery::IllegalValueError
    end

    it "id must be an HTTP(S) URI" do
      activity.id = 'test'
      expect{ activity.validate }.to raise_error IIIF::Discovery::IllegalValueError
    end

    it "id must be an HTTP(S) URI" do
      activity.id = 'https://example.com'
      expect{ activity.validate }.not_to raise_error
    end

    it "must have type" do
      activity.delete('type')
      expect{ activity.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "must have object" do
      activity.delete('object')
      expect{ activity.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end
  end
end
