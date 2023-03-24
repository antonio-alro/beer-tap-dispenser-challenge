require 'rails_helper'

RSpec.describe DomainFactories::UsageFactory, type: :domain_factory do
  subject(:domain_factory) { described_class }

  let(:usage_record) { build_stubbed(:usage_record) }
  let(:factory_result) { domain_factory.for(usage_record) }

  describe '#for' do
    it 'returns a category domain by default' do
      expect(described_class.for(usage_record)).to be_a(UsageEntity)
    end

    specify { expect(factory_result.id).to eq(usage_record.id) }
    specify { expect(factory_result.dispenser_id).to eq(usage_record.dispenser_id) }
    specify { expect(factory_result.opened_at).to eq(usage_record.opened_at) }
    specify { expect(factory_result.closed_at).to eq(usage_record.closed_at) }
    specify { expect(factory_result.flow_volume).to eq(usage_record.flow_volume) }
    specify { expect(factory_result.total_spent).to eq(usage_record.total_spent) }
    specify { expect(factory_result.created_at).to eq(usage_record.created_at) }
    specify { expect(factory_result.updated_at).to eq(usage_record.updated_at) }
  end
end
