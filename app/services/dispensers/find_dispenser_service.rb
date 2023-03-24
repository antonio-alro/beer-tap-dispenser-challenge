module Dispensers
  class FindDispenserService
    attr_reader :dispenser_repository

    def initialize(dispenser_id:, dispenser_repository: DispenserRepository)
      @dispenser_id = dispenser_id
      @dispenser_repository = dispenser_repository
    end

    def call
      dispenser_repository.find_by_id(dispenser_id)
    end

    attr_reader :dispenser_id
  end
end
