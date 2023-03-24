module Dispensers
  class UpdateDispenserService
    attr_reader :dispenser_repository

    def initialize(dispenser_id:, status:, dispenser_repository: DispenserRepository)
      @dispenser_id = dispenser_id
      @status = status
      @dispenser_repository = dispenser_repository
    end

    def call
      dispenser_repository.update(dispenser_id, status: status)
    end

    attr_reader :dispenser_id, :status
  end
end
