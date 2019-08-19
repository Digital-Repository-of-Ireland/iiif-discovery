require 'set'

shared_examples 'it has the appropriate methods for array-only keys' do

  described_class.new.array_only_keys.each do |prop|

    describe "#{prop}=" do
      let(:test_value) { described_class.new.type_only_keys.key?(prop) ? described_class.new.type_only_keys[prop].new : {'label' => 'XYZ'} }

      it "sets #{prop}" do
        ex = [test_value]
        subject.send("#{prop}=", ex)
        expect(subject[prop]).to eq ex
      end
      if prop.camelize(:lower) != prop
        it "is aliased as ##{prop.camelize(:lower)}=" do
          ex = [test_value]
          subject.send("#{prop.camelize(:lower)}=", ex)
          expect(subject[prop]).to eq ex
        end
      end
      it 'raises an exception when attempting to set it to something other than an Array' do
        expect { subject.send("#{prop}=", 'Foo') }.to raise_error IIIF::Discovery::IllegalValueError
      end
    end

    describe "#{prop}" do
      let(:test_value) { described_class.new.type_only_keys.key?(prop) ? described_class.new.type_only_keys[prop].new : {'label' => 'XYZ'} }

      it "gets #{prop}" do
        ex = [test_value]
        subject[prop] = ex
        expect(subject.send(prop)).to eq ex
      end
      if prop.camelize(:lower) != prop
        it "is aliased as ##{prop.camelize(:lower)}" do
          ex = [test_value]
          subject[prop] = ex
          expect(subject.send("#{prop.camelize(:lower)}")).to eq ex
        end
      end
    end

  end

end


