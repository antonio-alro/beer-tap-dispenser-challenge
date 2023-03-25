require 'rails_helper'

RSpec.describe Dispensers::StatusChanges::PerformCloseService, type: :service do
  let(:dispenser_entity) do
    DispenserEntity.new(id: '123e4567-e89b-12d3-a456-426614174000',
                        status: 'open',
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
  let(:closed_at) { opened_at + 20.seconds }

  describe '#call' do
    context 'when there is not any usage in progress' do
      it 'does not call services' do
        fake_get_usage_service = self.class::FakeEmptyGetInProgressUsageService.with_usage(usage_entity)

        service = described_class.new(
          dispenser_id: dispenser_entity.id,
          closed_at: closed_at,
          new_status: 'close',
          get_usage_service: fake_get_usage_service
        )

        expect(service.get_usage_service).to receive(:new)
          .with(dispenser_id: '123e4567-e89b-12d3-a456-426614174000')
          .and_call_original

        expect(service.repository).not_to receive(:execute_as_transaction)
        expect(service.update_dispenser_service).not_to receive(:new)
        expect(service.get_usage_total_spent_service).not_to receive(:new)
        expect(service.update_usage_service).not_to receive(:new)

        service.call
      end
    end

    context 'when there is an usage in progress' do
      context 'when the dispenser update has some errors' do
        it 'calls service to update the dispenser but it does not call service to update the usage' do
          fake_get_usage_service = self.class::FakeGetInProgressUsageService.with_usage(usage_entity)
          fake_repository = self.class::FakeRepository
          fake_update_dispenser_service = self.class::FakeErrorUpdateDispenserService.with_dispenser(dispenser_entity)

          service = described_class.new(
            dispenser_id: dispenser_entity.id,
            closed_at: closed_at,
            new_status: 'close',
            get_usage_service: fake_get_usage_service,
            repository: fake_repository,
            update_dispenser_service: fake_update_dispenser_service
          )

          expect(service.repository).to receive(:execute_as_transaction).and_call_original

          expect(service.update_dispenser_service).to receive(:new)
            .with(dispenser_id: '123e4567-e89b-12d3-a456-426614174000', status: 'close')
            .and_call_original

          expect(service.get_usage_total_spent_service).not_to receive(:new)
          expect(service.update_usage_service).not_to receive(:new)

          service.call
        end
      end

      context 'when the dispenser update has not any errors' do
        it 'calls services to update the dispenser and to update the usage' do
          fake_get_usage_service = self.class::FakeGetInProgressUsageService.with_usage(usage_entity)
          fake_repository = self.class::FakeRepository
          fake_update_dispenser_service = self.class::FakeUpdateDispenserService.with_dispenser(dispenser_entity)
          fake_update_usage_service = self.class::FakeUpdateUsageService.with_usage(usage_entity)
          fake_get_usage_total_spent_service = self.class::FakeGetTotalSpentService

          service = described_class.new(
            dispenser_id: dispenser_entity.id,
            closed_at: closed_at,
            new_status: 'close',
            get_usage_service: fake_get_usage_service,
            repository: fake_repository,
            update_dispenser_service: fake_update_dispenser_service,
            update_usage_service: fake_update_usage_service,
            get_usage_total_spent_service: fake_get_usage_total_spent_service
          )

          expect(service.repository).to receive(:execute_as_transaction).and_call_original

          expect(service.update_dispenser_service).to receive(:new)
            .with(dispenser_id: '123e4567-e89b-12d3-a456-426614174000', status: 'close')
            .and_call_original

          expect(service.get_usage_total_spent_service).to receive(:new)
            .with(started_at: opened_at, ended_at: closed_at, flow_volume: 0.0615)
            .and_call_original

          expect(service.update_usage_service).to receive(:new)
            .with(usage_id: '123e4567-e89b-12d3-a456-426614174000')
            .and_call_original

          service.call
        end
      end
    end
  end

  class self::FakeRepository
    def self.execute_as_transaction
      yield
    end
  end

  class self::FakeGetInProgressUsageService
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

  class self::FakeEmptyGetInProgressUsageService
    attr_reader :usage

    def self.with_usage(usage)
      @@usage = usage
      self
    end

    def initialize(*)
      self
    end

    def call(*)
      nil
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

  class self::FakeGetTotalSpentService
    def initialize(*)
      self
    end

    def call
      2.25
    end
  end

  class self::FakeUpdateUsageService
    attr_reader :usage

    def self.with_usage(usage)
      @@usage = usage
      self
    end

    def initialize(*)
      self
    end

    def call(*)
      { usage: @@usage, errors: [] }
    end
  end
end
