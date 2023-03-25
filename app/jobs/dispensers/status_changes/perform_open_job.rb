module Dispensers
  module StatusChanges
    class PerformOpenJob < ApplicationJob
      queue_as :default

      def perform(dispenser_id, dispenser_flow_volume, opened_at)
        Dispensers::StatusChanges::PerformOpenService.new(
          dispenser_id: dispenser_id,
          dispenser_flow_volume: dispenser_flow_volume,
          opened_at: opened_at
        ).call
      end
    end
  end
end
