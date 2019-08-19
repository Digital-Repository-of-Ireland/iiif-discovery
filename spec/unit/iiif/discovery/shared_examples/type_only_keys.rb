require 'set'

shared_examples 'it has the appropriate methods for type-only keys' do

  (described_class.new.type_only_keys.keys - described_class.new.array_only_keys).each do |prop|

    describe "#{prop}=" do
      it "sets #{prop}" do
        ex = described_class.new.type_only_keys[prop].new
        subject.send("#{prop}=", ex)
        expect(subject[prop]).to eq ex
      end
      it 'raises an exception when attempting to set it to something other than the expected type' do
        expect { subject.send("#{prop}=", ['Foo']) }.to raise_error IIIF::Discovery::IllegalValueError
      end
    end

    describe "#{prop}" do
      it "gets #{prop}" do
        ex = described_class.new.type_only_keys[prop].new
        subject[prop] = ex
        expect(subject.send(prop)).to eq ex
      end
    end

  end
end
