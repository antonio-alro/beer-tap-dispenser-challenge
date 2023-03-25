module Dispensers
  class UpdateStatusInput
    attr_reader :dispenser_params

    def initialize(dispenser_params:)
      @dispenser_params = dispenser_params
    end

    def dispenser_id
      dispenser_params.fetch(:id, nil)
    end

    def status
      dispenser_params.fetch(:status, nil)
    end

    def updated_at
      return if (updated_at = dispenser_params.fetch(:updated_at, nil)).blank?

      DateTime.parse(updated_at)
    end
  end
end
