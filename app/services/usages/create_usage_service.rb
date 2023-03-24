module Usages
  class CreateUsageService
    attr_reader :usage_repository

    def initialize(dispenser_id:, opened_at:, flow_volume:, usage_repository: UsageRepository)
      @dispenser_id = dispenser_id
      @opened_at = opened_at
      @flow_volume = flow_volume
      @usage_repository = usage_repository
    end

    def call
      usage_repository.create(dispenser_id: dispenser_id, opened_at: opened_at, flow_volume: flow_volume)
    end

    attr_reader :dispenser_id, :opened_at, :flow_volume
  end
end
