require 'rails_helper'

RSpec.describe DomainFactories::DispenserFactory, type: :domain_factory do
  subject(:domain_factory) { described_class }

  let(:dispenser_record) { build_stubbed(:dispenser_record) }
  let(:factory_result) { domain_factory.for(dispenser_record) }

  describe '#for' do
    it 'returns a category domain by default' do
      expect(described_class.for(dispenser_record)).to be_a(DispenserEntity)
    end

    specify { expect(factory_result.id).to eq(dispenser_record.id) }
    specify { expect(factory_result.status).to eq(dispenser_record.status) }
    specify { expect(factory_result.flow_volume).to eq(dispenser_record.flow_volume) }
    specify { expect(factory_result.created_at).to eq(dispenser_record.created_at) }
    specify { expect(factory_result.updated_at).to eq(dispenser_record.updated_at) }
  end
end
