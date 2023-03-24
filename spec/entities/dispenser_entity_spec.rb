require 'rails_helper'

RSpec.describe DispenserEntity, type: :entity do
  subject(:domain_entity) do
    described_class.new(id: id, status: status, flow_volume: flow_volume, created_at: created_at, updated_at: updated_at)
  end

  let(:id) { '123e4567-e89b-12d3-a456-426614174000' }
  let(:status) { 'close' }
  let(:flow_volume) { 0.0615 }
  let(:created_at) { 2.days.ago }
  let(:updated_at) { created_at }

  specify { expect(domain_entity.id).to eq('123e4567-e89b-12d3-a456-426614174000') }
  specify { expect(domain_entity.status).to eq('close') }
  specify { expect(domain_entity.flow_volume).to eq(0.0615) }
  specify { expect(domain_entity.created_at).to eq(created_at) }
  specify { expect(domain_entity.updated_at).to eq(updated_at) }

  describe '.OPEN_STATUS' do
    specify { expect(described_class::OPEN_STATUS).to eq('open') }
  end

  describe '.CLOSE_STATUS' do
    specify { expect(described_class::CLOSE_STATUS).to eq('close') }
  end
end
