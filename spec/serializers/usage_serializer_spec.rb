require 'rails_helper'

RSpec.describe UsageSerializer, type: :serializer do
  subject(:serializer) { described_class.new(usage_entity) }

  let(:usage_entity) do
    UsageEntity.new(id: '123e4567-e89b-12d3-a456-426614174000',
                    dispenser_id: '765e4321-e89b-12d3-a456-426610184111',
                    opened_at: opened_at,
                    closed_at: opened_at + 20.seconds,
                    flow_volume: 0.0615,
                    total_spent: total_spent,
                    created_at: 2.days.ago,
                    updated_at: 2.days.ago)
  end
  let(:opened_at) { Time.current }
  let(:total_spent) { 1.23 }

  describe '#serializable_hash' do
    it 'returns the expected JSON' do
      serialized_hash = serializer.serializable_hash
      expected_hash = {
        'opened_at' => usage_entity.opened_at.strftime("%FT%T.%LZ"),
        'closed_at' => usage_entity.closed_at.strftime("%FT%T.%LZ"),
        'flow_volume' => 0.0615,
        "total_spent" => 1.23
      }

      expect(serialized_hash).to eq(expected_hash)
    end

    context 'when the usage has not total spent' do
      let(:total_spent) { nil }

      it 'returns the expected JSON' do
        usage_entity.estimated_total_spent = 11.6
        serialized_hash = serializer.serializable_hash
        expected_hash = {
          'opened_at' => usage_entity.opened_at.strftime("%FT%T.%LZ"),
          'closed_at' => usage_entity.closed_at.strftime("%FT%T.%LZ"),
          'flow_volume' => 0.0615,
          "total_spent" => 11.6
        }

        expect(serialized_hash).to eq(expected_hash)
      end
    end
  end
end
