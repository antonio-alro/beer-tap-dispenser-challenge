require 'rails_helper'

RSpec.describe Dispensers::CreateDispenserUseCase, type: :use_case do
  let(:dispenser_entity) do
    DispenserEntity.new(id: '123e4567-e89b-12d3-a456-426614174000',
                        status: 'close',
                        flow_volume: 0.0615,
                        created_at: 2.days.ago,
                        updated_at: 2.days.ago)
  end

  describe '#perform' do
    it 'calls service to create the dispenser record' do
      fake_input = self.class::FakeInput.new
      fake_create_dispenser_service = self.class::FakeCreateDispenserService.with_dispenser(dispenser_entity)
      use_case = described_class.new(create_dispenser_service: fake_create_dispenser_service)

      expect(use_case.create_dispenser_service).to receive(:new).with(flow_volume: 0.055).and_call_original

      use_case.perform(input: fake_input)
    end

    it 'returns the dispenser has been created' do
      fake_input = self.class::FakeInput.new
      fake_create_dispenser_service = self.class::FakeCreateDispenserService.with_dispenser(dispenser_entity)
      use_case = described_class.new(create_dispenser_service: fake_create_dispenser_service)

      expect(use_case.perform(input: fake_input)).to eq(dispenser_entity)
    end
  end

  class self::FakeCreateDispenserService
    attr_reader :dispenser

    def self.with_dispenser(dispenser)
      @@dispenser = dispenser
      self
    end

    def initialize(*); end

    def call(*)
      @@dispenser
    end
  end

  class self::FakeInput
    def initialize(*); end

    def flow_volume
      0.055
    end
  end
end
