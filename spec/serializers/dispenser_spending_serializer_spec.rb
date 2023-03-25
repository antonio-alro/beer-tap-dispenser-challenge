require 'rails_helper'

RSpec.describe DispenserSpendingSerializer, type: :serializer do
  subject(:serializer) { described_class.new(dispenser_spending_entity) }

  let(:dispenser_spending_entity) { DispenserSpendingEntity.new(usages: [usage_entity]) }
  let(:usage_entity) do
    UsageEntity.new(id: id,
                    dispenser_id: dispenser_id,
                    opened_at: opened_at,
                    closed_at: closed_at,
                    flow_volume: flow_volume,
                    total_spent: total_spent,
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

  describe '#serializable_hash' do
    it 'returns the expected JSON' do
      serialized_hash = serializer.serializable_hash
      expected_hash = {
        'amount' => 15.238,
        'usages' => [
          {
            'opened_at' => usage_entity.opened_at.strftime("%FT%T.%LZ"),
            'closed_at' => usage_entity.closed_at.strftime("%FT%T.%LZ"),
            'flow_volume' => 0.0615,
            "total_spent" => 15.238
          }
        ]
      }

      expect(serialized_hash).to eq(expected_hash)
    end
  end
end
