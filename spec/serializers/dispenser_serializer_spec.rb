require 'rails_helper'

RSpec.describe DispenserSerializer, type: :serializer do
  subject(:serializer) { described_class.new(dispenser_entity) }

  let(:dispenser_entity) do
    DispenserEntity.new(id: '123e4567-e89b-12d3-a456-426614174000',
                        status: 'close',
                        flow_volume: 0.0615,
                        created_at: 2.days.ago,
                        updated_at: 2.days.ago)
  end

  describe '#serializable_hash' do
    it 'returns the expected JSON' do
      serialized_hash = serializer.serializable_hash
      expected_hash = { 'id' => '123e4567-e89b-12d3-a456-426614174000', 'flow_volume' => 0.0615 }

      expect(serialized_hash).to eq(expected_hash)
    end
  end
end
