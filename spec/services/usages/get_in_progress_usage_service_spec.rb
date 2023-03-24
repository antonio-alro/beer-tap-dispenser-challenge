require 'rails_helper'

RSpec.describe Usages::GetInProgressUsageService, type: :service do
  let(:usage_entity) do
    UsageEntity.new(id: '123e4567-e89b-12d3-a456-426614174000',
                    dispenser_id: '765e4321-e89b-12d3-a456-426610184111',
                    opened_at: opened_at,
                    closed_at: nil,
                    flow_volume: 0.0615,
                    total_spent: nil,
                    created_at: 2.days.ago,
                    updated_at: 2.days.ago)
  end
  let(:opened_at) { Time.current }

  describe '#call' do
    it 'calls repository method to get the expected usage record' do
      fake_usage_repository = self.class::FakeUsageRepository.with_usage(usage_entity)
      service = described_class.new(dispenser_id: 'fake_id', usage_repository: fake_usage_repository)

      expect(service.usage_repository).to receive(:find_in_progress_usage).with(dispenser_id: 'fake_id').and_call_original

      service.call
    end

    it 'returns the expected dispenser' do
      fake_usage_repository = self.class::FakeUsageRepository.with_usage(usage_entity)
      service = described_class.new(dispenser_id: 'fake_id', usage_repository: fake_usage_repository)

      expect(service.call).to eq(usage_entity)
    end
  end

  class self::FakeUsageRepository
    attr_reader :usage

    def self.with_usage(usage)
      @@usage = usage
      self
    end

    def self.find_in_progress_usage(*)
      @@usage
    end
  end
end
