module Dispensers
  module StatusChanges
    class PerformCloseJob < ApplicationJob
      queue_as :default

      def perform(dispenser_id, closed_at)
        Dispensers::StatusChanges::PerformCloseService.new(
          dispenser_id: dispenser_id,
          closed_at: closed_at
        ).call
      end
    end
  end
end
