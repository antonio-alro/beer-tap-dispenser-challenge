module Dispensers
  class CreateDispenserUseCase
    attr_reader :create_dispenser_service

    def initialize(create_dispenser_service: Dispensers::CreateDispenserService)
      @create_dispenser_service = create_dispenser_service
    end

    def perform(input:)
      dispenser = create_dispenser_service.new(flow_volume: input.flow_volume).call

      dispenser
    end
  end
end
