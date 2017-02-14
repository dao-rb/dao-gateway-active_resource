describe Dao::Gateway::ActiveResource::Base do
  let(:entity) { OrganizationEntity }
  let(:transformer) { Dao::Gateway::ActiveResource::BaseTransformer.new(entity) }
  let(:source) { Organization }
  let(:gateway) { described_class.new(source, transformer) }

  subject { gateway }

  its(:source) { is_expected.to eq source }
  its(:transformer) { is_expected.to eq transformer }
  its(:black_list_attributes) { is_expected.to eq [] }

  it 'should build entity' do
    organization = Organization.find(44)
    expect(subject.map(organization, nil)).to be_a OrganizationEntity
  end

  it 'should save entity' do
    organization = OrganizationEntity.new(id: 1, name: 'name', full_name: 'full name')
    expect_any_instance_of(Organization).to receive(:save!)

    expect(subject.save!(organization, nil).object_id).to eq organization.object_id
  end

  describe 'exceptions' do
    describe '#chain' do
      class Organization
        def self.foo; end
      end

      describe 'Dao::Gateway::RecordNotFound' do
        before do
          expect(Organization).to receive(:foo).and_raise(ActiveResource::ResourceNotFound.new(double(message: 'error message')))
        end

        it 'should raise error' do
          expect{ gateway.chain(Organization, :foo, {}) }.to raise_error(Dao::Gateway::RecordNotFound, 'Failed.  Response message = error message.')
        end
      end

      describe 'Dao::Gateway::InvalidRecord' do
        before do
          expect(Organization).to receive(:foo).and_raise(ActiveResource::ResourceInvalid.new(response))
        end

        context 'when response is a kind of source' do
          let(:response) do
            Organization.new.tap do |res|
              allow(res).to receive(:errors).and_return(foo: :bar)
            end
          end

          it 'should raise error' do
            expect{ gateway.chain(Organization, :foo, {}) }.to raise_error(Dao::Gateway::InvalidRecord)
          end

          it 'should save error messages' do
            begin
              gateway.chain(Organization, :foo, {})
            rescue Dao::Gateway::InvalidRecord => e
              expect(e.errors).to eq(foo: :bar)
            end
          end
        end

        context 'when response is plain' do
          let(:response) { Struct.new(:body).new( "{\"errors\":{\"name\":\"invalid\"}}") }

          it 'should save error message' do
            begin
              gateway.chain(Organization, :foo, {})
            rescue Dao::Gateway::InvalidRecord => e
              expect(e.errors).to eq('name' => 'invalid')
            end
          end
        end
      end

      describe 'Dao::Gateway::ForbiddenRecord' do
        before do
          expect(Organization).to receive(:foo).and_raise(ActiveResource::ForbiddenAccess.new(double(message: 'error message')))
        end

        it 'should raise error' do
          expect{ gateway.chain(Organization, :foo, {}) }.to raise_error(Dao::Gateway::ForbiddenRecord, 'Failed.  Response message = error message.')
        end
      end
    end
  end
end
