module Dispensers
  module StatusChanges
    class PerformOpenService
      attr_reader :repository, :update_dispenser_service, :create_usage_service

      def initialize(dispenser_id:,
                     dispenser_flow_volume:,
                     opened_at:,
                     new_status: DispenserEntity::OPEN_STATUS,
                     repository: DispenserRepository,
                     update_dispenser_service: Dispensers::UpdateDispenserService,
                     create_usage_service: Usages::CreateUsageService)
        @dispenser_id = dispenser_id
        @dispenser_flow_volume = dispenser_flow_volume
        @opened_at = opened_at
        @new_status =  new_status
        @repository = repository
        @update_dispenser_service = update_dispenser_service
        @create_usage_service = create_usage_service
      end

      def call
        repository.execute_as_transaction do
          result = update_dispenser_status
          create_dispenser_usage if result[:errors].blank?
        end
      end

      private

      attr_reader :dispenser_id, :dispenser_flow_volume, :opened_at, :new_status

      def update_dispenser_status
        update_dispenser_service.new(dispenser_id: dispenser_id, status: new_status).call
      end

      def create_dispenser_usage
        create_usage_service.new(
          dispenser_id: dispenser_id,
          opened_at: opened_at,
          flow_volume: dispenser_flow_volume
        ).call
      end
    end
  end
end
