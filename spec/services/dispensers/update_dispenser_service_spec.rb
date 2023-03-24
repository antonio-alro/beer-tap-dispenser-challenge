require 'rails_helper'

RSpec.describe Dispensers::UpdateDispenserService, type: :service do
  let(:dispenser_entity) do
    DispenserEntity.new(id: '123e4567-e89b-12d3-a456-426614174000',
                        status: 'close',
                        flow_volume: 0.0615,
                        created_at: 2.days.ago,
                        updated_at: 2.days.ago)
  end

  describe '#call' do
    it 'calls repository method to update the dispenser record' do
      fake_dispenser_repository = self.class::FakeDispenserRepository.with_dispenser(dispenser_entity)
      service = described_class.new(dispenser_id: 'fake_id', status: 'open', dispenser_repository: fake_dispenser_repository)

      expect(service.dispenser_repository).to receive(:update).with('fake_id', status: 'open').and_call_original

      service.call
    end
  end

  class self::FakeDispenserRepository
    attr_reader :dispenser

    def self.with_dispenser(dispenser)
      @@dispenser = dispenser
      self
    end

    def self.update(*)
      { dispenser: @@dispenser, errors: [] }
    end
  end
end
