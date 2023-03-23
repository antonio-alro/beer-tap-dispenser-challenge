module Dispensers
  class CreateDispenserService
    attr_reader :dispenser_repository

    def initialize(flow_volume:, dispenser_repository: DispenserRepository)
      @flow_volume = flow_volume
      @dispenser_repository = dispenser_repository
    end

    def call
      dispenser_repository.create(flow_volume: flow_volume)
    end

    attr_reader :flow_volume
  end
end
