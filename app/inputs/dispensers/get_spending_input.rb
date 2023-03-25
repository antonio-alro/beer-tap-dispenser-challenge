module Dispensers
  class GetSpendingInput
    attr_reader :dispenser_params, :requested_at

    def initialize(dispenser_params:, requested_at:)
      @dispenser_params = dispenser_params
      @requested_at = requested_at.freeze
    end

    def dispenser_id
      dispenser_params.fetch(:id, nil)
    end
  end
end
