module Dispensers
  class CreateDispenserInput
    attr_reader :dispenser_params

    def initialize(dispenser_params:)
      @dispenser_params = dispenser_params
    end

    def flow_volume
      dispenser_params.fetch(:flow_volume, nil)
    end
  end
end
