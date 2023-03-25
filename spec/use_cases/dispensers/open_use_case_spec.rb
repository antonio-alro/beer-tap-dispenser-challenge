require 'rails_helper'

RSpec.describe Dispensers::OpenUseCase, type: :use_case do
  let(:dispenser_entity) do
    DispenserEntity.new(id: '123e4567-e89b-12d3-a456-426614174000',
                        status: 'close',
                        flow_volume: 0.0615,
                        created_at: 2.days.ago,
                        updated_at: 2.days.ago)
  end
  let(:updated_at) { Time.current }
  let(:input_params) do
    { dispenser_id: '123e4567-e89b-12d3-a456-426614174000', updated_at: updated_at }
  end

  describe '#perform' do
    context 'when the dispenser is not found' do
      it 'raises a custom error' do
        fake_input = self.class::FakeUpdateStatusInput.new(dispenser_params: input_params)
        fake_find_dispenser_service = self.class::FakeNotFoundFindDispenserService

        use_case = described_class.new(
          find_dispenser_service: fake_find_dispenser_service,
          use_case_error: self.class::FakeUseCaseError
        )

        expect{
          use_case.perform(input: fake_input)
        }.to raise_error(self.class::FakeUseCaseError)
      end
    end

    context 'when the dispenser is found' do
      context 'but the status change is invalid' do
        it 'raises a custom error' do
          fake_input = self.class::FakeUpdateStatusInput.new(dispenser_params: input_params)
          fake_find_dispenser_service = self.class::FakeFindDispenserService.with_dispenser(dispenser_entity)
          fake_check_status_change_service = self.class::FakeInvalidCheckStatusChangeService

          use_case = described_class.new(
            find_dispenser_service: fake_find_dispenser_service,
            check_status_change_service: fake_check_status_change_service,
            invalid_dispenser_status_change_error: self.class::FakeInvalidDispenserStatusChangeError
          )

          expect{
            use_case.perform(input: fake_input)
          }.to raise_error(self.class::FakeInvalidDispenserStatusChangeError)
        end
      end

      context 'and the status change is valid' do
        it 'calls service to open the dispenser' do
          fake_input = self.class::FakeUpdateStatusInput.new(dispenser_params: input_params)
          fake_find_dispenser_service = self.class::FakeFindDispenserService.with_dispenser(dispenser_entity)
          fake_check_status_change_service = self.class::FakeValidCheckStatusChangeService
          fake_perform_open_service = self.class::FakePerformOpenService

          use_case = described_class.new(
            find_dispenser_service: fake_find_dispenser_service,
            check_status_change_service: fake_check_status_change_service,
            perform_open_service: fake_perform_open_service
          )

          expect(use_case.find_dispenser_service).to receive(:new)
            .with(dispenser_id: '123e4567-e89b-12d3-a456-426614174000')
            .and_call_original

          expect(use_case.perform_open_service).to receive(:new)
            .with(dispenser_id: '123e4567-e89b-12d3-a456-426614174000', dispenser_flow_volume: 0.0615, opened_at: updated_at)
            .and_call_original

          use_case.perform(input: fake_input)
        end
      end
    end
  end

  class self::FakeUpdateStatusInput
    attr_reader :dispenser_params

    def initialize(dispenser_params:)
      @dispenser_params = dispenser_params
    end

    def dispenser_id
      dispenser_params[:dispenser_id]
    end

    def status
      'open'
    end

    def updated_at
      dispenser_params[:updated_at]
    end
  end

  class self::FakeUseCaseError < BaseError
    def initialize(*); end
  end

  class self::FakeInvalidDispenserStatusChangeError < BaseError
    def initialize(*); end
  end

  class self::FakeNotFoundFindDispenserService
    def initialize(*)
      self
    end

    def call(*)
      nil
    end
  end

  class self::FakeFindDispenserService
    attr_reader :dispenser

    def self.with_dispenser(dispenser)
      @@dispenser = dispenser
      self
    end

    def initialize(*)
      self
    end

    def call(*)
      @@dispenser
    end
  end

  class self::FakeInvalidCheckStatusChangeService
    def initialize(*)
      self
    end

    def call(*)
      false
    end
  end

  class self::FakeValidCheckStatusChangeService
    def initialize(*)
      self
    end

    def call(*)
      true
    end
  end

  class self::FakePerformOpenService
    def initialize(*)
      self
    end

    def call(*)
      true
    end
  end
end
