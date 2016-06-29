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
end
