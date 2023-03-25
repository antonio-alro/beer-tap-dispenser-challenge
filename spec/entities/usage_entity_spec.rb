require 'rails_helper'

RSpec.describe UsageEntity, type: :entity do
  subject(:domain_entity) do
    described_class.new(id: id,
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

  specify { expect(domain_entity.id).to eq('123e4567-e89b-12d3-a456-426614174000') }
  specify { expect(domain_entity.dispenser_id).to eq('765e45321-e89b-12d3-a456-116622173555') }
  specify { expect(domain_entity.opened_at).to eq(opened_at) }
  specify { expect(domain_entity.closed_at).to eq(closed_at) }
  specify { expect(domain_entity.flow_volume).to eq(0.0615) }
  specify { expect(domain_entity.total_spent).to eq(15.238) }
  specify { expect(domain_entity.created_at).to eq(created_at) }
  specify { expect(domain_entity.updated_at).to eq(updated_at) }

  describe '#estimated_total_spent=' do
    it 'sets the proper estimated_total_spent' do
      domain_entity.estimated_total_spent = 10.5

      expect(domain_entity.estimated_total_spent).to eq(10.5)
    end
  end
end
