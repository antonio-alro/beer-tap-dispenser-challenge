module Dispensers
  module StatusChanges
    class PerformCloseService
      attr_reader :get_usage_service,
                  :repository,
                  :update_dispenser_service,
                  :update_usage_service,
                  :get_usage_total_spent_service

      def initialize(dispenser_id:,
                     closed_at:,
                     new_status: DispenserEntity::CLOSE_STATUS,
                     get_usage_service: Usages::GetInProgressUsageService,
                     repository: UsageRepository,
                     update_dispenser_service: Dispensers::UpdateDispenserService,
                     update_usage_service: Usages::UpdateUsageService,
                     get_usage_total_spent_service: Usages::GetTotalSpentService)
        @dispenser_id = dispenser_id
        @closed_at = closed_at
        @new_status =  new_status
        @get_usage_service = get_usage_service
        @repository = repository
        @update_dispenser_service = update_dispenser_service
        @update_usage_service = update_usage_service
        @get_usage_total_spent_service = get_usage_total_spent_service
      end

      def call
        in_progress_usage = find_in_progress_usage

        return if in_progress_usage.blank?

        repository.execute_as_transaction do
          result = update_dispenser_status
          update_usage_closed_at(usage: in_progress_usage) if result[:errors].blank?
        end
      end

      private

      attr_reader :dispenser_id, :closed_at, :new_status

      def find_in_progress_usage
        get_usage_service.new(dispenser_id: dispenser_id).call
      end

      def update_dispenser_status
        update_dispenser_service.new(dispenser_id: dispenser_id, status: new_status).call
      end

      def update_usage_closed_at(usage:)
        total_spent = get_total_spent(usage: usage)

        update_usage_service.new(usage_id: usage.id).call(closed_at: closed_at, total_spent: total_spent)
      end

      def get_total_spent(usage:)
        get_usage_total_spent_service.new(started_at: usage.opened_at,
                                          ended_at: closed_at,
                                          flow_volume: usage.flow_volume).call
      end
    end
  end
end
