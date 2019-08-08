describe IIIF::Discovery::Service do

  describe 'self#get_descendant_class_by_jld_type' do
    before do
      class DummyClass < IIIF::Discovery::Service
        TYPE = "OrderedCollection"
        def self.singleton_class?
          true
        end
      end
    end
    after do
      Object.send(:remove_const, :DummyClass)
    end
    it 'gets the right class' do
      klass = described_class.get_descendant_class_by_jld_type('OrderedCollection')
      expect(klass).to be IIIF::Discovery::OrderedCollection
    end
    context "when there are singleton classes which are returned" do
      it "gets the right class" do
        allow(IIIF::Discovery::Service).to receive(:descendants).and_return([DummyClass, IIIF::Discovery::OrderedCollection])
        klass = described_class.get_descendant_class_by_jld_type('OrderedCollection')
        expect(klass).to be IIIF::Discovery::OrderedCollection
      end
    end
  end

end
