module Usages
  class UpdateUsageService
    attr_reader :usage_repository

    def initialize(usage_id:, usage_repository: UsageRepository)
      @usage_id = usage_id
      @usage_repository = usage_repository
    end

    def call(**args)
      usage_repository.update(usage_id, **args)
    end

    attr_reader :usage_id
  end
end
