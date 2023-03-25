require 'rails_helper'

RSpec.describe Dispensers::StatusChanges::PerformOpenService, type: :service do
  let(:dispenser_entity) do
    DispenserEntity.new(id: '123e4567-e89b-12d3-a456-426614174000',
                        status: 'close',
                        flow_volume: 0.0615,
                        created_at: 2.days.ago,
                        updated_at: 2.days.ago)
  end
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
    context 'when the dispenser update has some errors' do
      it 'calls service to update the dispenser but it does not call service to create the usage' do
        fake_repository = self.class::FakeRepository
        fake_update_dispenser_service = self.class::FakeErrorUpdateDispenserService.with_dispenser(dispenser_entity)
        fake_create_usage_service = self.class::FakeCreateUsageService.with_usage(usage_entity)

        service = described_class.new(
          dispenser_id: dispenser_entity.id,
          dispenser_flow_volume: dispenser_entity.flow_volume,
          opened_at: opened_at,
          new_status: 'open',
          repository: fake_repository,
          update_dispenser_service: fake_update_dispenser_service,
          create_usage_service: fake_create_usage_service
        )

        expect(service.repository).to receive(:execute_as_transaction).and_call_original

        expect(service.update_dispenser_service).to receive(:new)
          .with(dispenser_id: '123e4567-e89b-12d3-a456-426614174000', status: 'open')
          .and_call_original

        expect(service.create_usage_service).not_to receive(:new)

        service.call
      end
    end

    context 'when the dispenser update has not any errors' do
      it 'calls services to update the dispenser and create the usage' do
        fake_repository = self.class::FakeRepository
        fake_update_dispenser_service = self.class::FakeUpdateDispenserService.with_dispenser(dispenser_entity)
        fake_create_usage_service = self.class::FakeCreateUsageService.with_usage(usage_entity)

        service = described_class.new(
          dispenser_id: dispenser_entity.id,
          dispenser_flow_volume: dispenser_entity.flow_volume,
          opened_at: opened_at,
          new_status: 'open',
          repository: fake_repository,
          update_dispenser_service: fake_update_dispenser_service,
          create_usage_service: fake_create_usage_service
        )

        expect(service.repository).to receive(:execute_as_transaction).and_call_original

        expect(service.update_dispenser_service).to receive(:new)
          .with(dispenser_id: '123e4567-e89b-12d3-a456-426614174000', status: 'open')
          .and_call_original

        expect(service.create_usage_service).to receive(:new)
          .with(dispenser_id: '123e4567-e89b-12d3-a456-426614174000', opened_at: opened_at, flow_volume: 0.0615)
          .and_call_original

        service.call
      end
    end
  end

  class self::FakeRepository
    def self.execute_as_transaction
      yield
    end
  end

  class self::FakeUpdateDispenserService
    attr_reader :dispenser

    def self.with_dispenser(dispenser)
      @@dispenser = dispenser
      self
    end

    def initialize(*)
      self
    end

    def call(*)
      { dispenser: @@dispenser, errors: [] }
    end
  end

  class self::FakeErrorUpdateDispenserService
    attr_reader :dispenser

    def self.with_dispenser(dispenser)
      @@dispenser = dispenser
      self
    end

    def initialize(*)
      self
    end

    def call(*)
      { dispenser: @@dispenser, errors: ['Error'] }
    end
  end

  class self::FakeCreateUsageService
    attr_reader :usage

    def self.with_usage(usage)
      @@usage = usage
      self
    end

    def initialize(*)
      self
    end

    def call(*)
      @@usage
    end
  end
end
