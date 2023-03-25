require 'rails_helper'

RSpec.describe DispenserSpendingEntity, type: :entity do
  subject(:domain_entity) { described_class.new(usages: [usage_entity_1, usage_entity_2]) }

  let(:usage_entity_1) do
    UsageEntity.new(id: id,
                    dispenser_id: dispenser_id,
                    opened_at: opened_at,
                    closed_at: closed_at,
                    flow_volume: flow_volume,
                    total_spent: total_spent,
                    created_at: created_at,
                    updated_at: updated_at)
  end
  let(:usage_entity_2) do
    UsageEntity.new(id: id,
                    dispenser_id: dispenser_id,
                    opened_at: opened_at,
                    closed_at: closed_at,
                    flow_volume: flow_volume,
                    total_spent: nil,
                    created_at: created_at,
                    updated_at: updated_at)
  end
  let(:id) { '123e4567-e89b-12d3-a456-426614174000' }
  let(:dispenser_id) { '765e45321-e89b-12d3-a456-116622173555' }
  let(:opened_at) { 2.days.ago }
  let(:closed_at) { opened_at + 20.seconds }
  let(:flow_volume) { 0.0615 }
  let(:total_spent) { 15.238 }
  let(:created_at) { opened_at }
  let(:updated_at) { opened_at }

  specify { expect(domain_entity.usages).to eq([usage_entity_1, usage_entity_2]) }

  describe '#amount' do
    before do
      usage_entity_2.estimated_total_spent = 10.0
    end

    it 'returns the expected amount' do
      expect(domain_entity.amount).to eq(25.238)
    end
  end
end
