require 'rails_helper'

RSpec.describe Dispensers::GetSpendingUseCase, type: :use_case do
  let(:usage_entity) do
    UsageEntity.new(id: '123e4567-e89b-12d3-a456-426614174000',
                    dispenser_id: '765e4321-e89b-12d3-a456-426610184111',
                    opened_at: opened_at,
                    closed_at: nil,
                    flow_volume: 0.0615,
                    total_spent: total_spent,
                    created_at: 2.days.ago,
                    updated_at: 2.days.ago)
  end
  let(:opened_at) { Time.current }
  let(:requested_at) { opened_at + 30.seconds }

  describe '#perform' do
    context 'when the found usage has total spent' do
      let(:total_spent) { 5.34 }

      it 'calls service to get usages but does not call service to calculate the total spent' do
        fake_input = self.class::FakeGetSpendingInput.new(dispenser_params: {}, requested_at: requested_at)
        fake_get_dispenser_usages_service = self.class::FakeGetUsagesByDispenserService.with_usages([usage_entity])
        fake_get_total_spent_service = self.class::FakeGetTotalSpentService
        fake_spending_entity = self.class::FakeDispenserSpendingEntity

        use_case = described_class.new(
          get_dispenser_usages_service: fake_get_dispenser_usages_service,
          get_total_spent_service: fake_get_total_spent_service,
          spending_entity: fake_spending_entity
        )

        expect(use_case.get_dispenser_usages_service).to receive(:new)
          .with(dispenser_id: 'fake_dispenser_id')
          .and_call_original

        expect(use_case.get_total_spent_service).not_to receive(:new)

        expect(use_case.spending_entity).to receive(:new).with(usages: [usage_entity]).and_call_original

        use_case.perform(input: fake_input)
      end
    end

    context 'when the found usage has not total spent' do
      let(:total_spent) { nil }

      it 'calls service to get usages and call service to calculate the total spent' do
        fake_input = self.class::FakeGetSpendingInput.new(dispenser_params: {}, requested_at: requested_at)
        fake_get_dispenser_usages_service = self.class::FakeGetUsagesByDispenserService.with_usages([usage_entity])
        fake_get_total_spent_service = self.class::FakeGetTotalSpentService
        fake_spending_entity = self.class::FakeDispenserSpendingEntity

        use_case = described_class.new(
          get_dispenser_usages_service: fake_get_dispenser_usages_service,
          get_total_spent_service: fake_get_total_spent_service,
          spending_entity: fake_spending_entity
        )

        expect(use_case.get_dispenser_usages_service).to receive(:new)
          .with(dispenser_id: 'fake_dispenser_id')
          .and_call_original

        expect(use_case.get_total_spent_service).to receive(:new)
          .with(started_at: opened_at, ended_at: requested_at, flow_volume: 0.0615)
          .and_call_original

        expect(usage_entity).to receive(:estimated_total_spent=).with(2.25)

        expect(use_case.spending_entity).to receive(:new).with(usages: [usage_entity]).and_call_original

        use_case.perform(input: fake_input)
      end
    end
  end

  class self::FakeGetSpendingInput
    attr_reader :requested_at

    def initialize(dispenser_params:, requested_at:)
      @requested_at = requested_at
    end

    def dispenser_id
      'fake_dispenser_id'
    end
  end

  class self::FakeGetUsagesByDispenserService
    attr_reader :usages

    def self.with_usages(usages)
      @@usages = usages
      self
    end

    def initialize(*)
      self
    end

    def call
      @@usages
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

  class self::FakeDispenserSpendingEntity
    attr_reader :usages

    def initialize(usages:)
      @usages = usages
    end
  end
end
