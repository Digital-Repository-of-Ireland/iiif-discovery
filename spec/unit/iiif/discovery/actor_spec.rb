describe IIIF::Discovery::Actor do

  let(:fixed_values) do
  {
    "id" => "https://example.org/person/admin1",
    "type" => "Person",
  }
  end

  describe '#initialize' do
    it 'sets type' do
      expect(subject['type']).to eq 'Application'
    end
  end

  describe "#{described_class}.define_methods_for_string_only_keys" do
    it_behaves_like 'it has the appropriate methods for string-only keys'
  end

  context 'validation' do

    let(:actor) { IIIF::Discovery::Service.parse(fixed_values) }

    it "must have an id" do
      actor.delete('id')
      expect{ actor.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "id must be a string" do
      expect{ actor.id = nil }.to raise_error IIIF::Discovery::IllegalValueError
    end

    it "id must be an HTTP(S) URI" do
      actor.id = 'test'
      expect{ actor.validate }.to raise_error IIIF::Discovery::IllegalValueError
    end

    it "id must be an HTTP(S) URI" do
      actor.id = 'https://example.com'
      expect{ actor.validate }.not_to raise_error
    end

    it "must have type" do
      actor.delete('type')
      expect{ actor.validate }.to raise_error IIIF::Discovery::MissingRequiredKeyError
    end

    it "type must be one of the allowed" do
      actor.type = 'test'
      expect{ actor.validate }.to raise_error IIIF::Discovery::IllegalValueError
    end
  end
end
