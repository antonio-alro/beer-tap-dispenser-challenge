module Dispensers
  class GetSpendingUseCase
    attr_reader :get_dispenser_usages_service, :get_total_spent_service, :spending_entity

    def initialize(get_dispenser_usages_service: Usages::GetUsagesByDispenserService,
                   get_total_spent_service: Usages::GetTotalSpentService,
                   spending_entity: DispenserSpendingEntity)
      @get_dispenser_usages_service = get_dispenser_usages_service
      @get_total_spent_service = get_total_spent_service
      @spending_entity = spending_entity
    end

    def perform(input:)
      usages = get_dispenser_usages_service.new(dispenser_id: input.dispenser_id).call

      usages.each do |usage|
        next unless usage.total_spent.nil?

        estimated_total_spent = get_total_spent_service.new(
          started_at: usage.opened_at,
          ended_at: input.requested_at,
          flow_volume: usage.flow_volume
        ).call

        usage.estimated_total_spent = estimated_total_spent
      end

      spending_entity.new(usages: usages)
    end
  end
end
