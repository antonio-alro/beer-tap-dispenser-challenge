module Dispensers
  class CheckStatusChangeService
    def initialize(current_status:, new_status:)
      @current_status = current_status
      @new_status = new_status
    end

    def call
      return false if new_status.blank?

      valid_status_change?(current_status: current_status, new_status: new_status)
    end

    private

    attr_reader :current_status, :new_status

    def valid_status_change?(current_status:, new_status:)
      current_status != new_status
    end
  end
end
