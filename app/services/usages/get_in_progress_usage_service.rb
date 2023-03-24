module Usages
  class GetInProgressUsageService
    attr_reader :usage_repository

    def initialize(dispenser_id:, usage_repository: UsageRepository)
      @dispenser_id = dispenser_id
      @usage_repository = usage_repository
    end

    def call
      usage_repository.find_in_progress_usage(dispenser_id: dispenser_id)
    end

    attr_reader :dispenser_id
  end
end
