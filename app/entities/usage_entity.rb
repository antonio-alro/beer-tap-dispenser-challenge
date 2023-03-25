class UsageEntity
  attr_reader :id, :dispenser_id, :opened_at, :closed_at, :flow_volume, :total_spent, :created_at, :updated_at
  attr_accessor :estimated_total_spent

  def initialize(id:, dispenser_id:, opened_at:, closed_at:, flow_volume:, total_spent:, created_at:, updated_at:)
    @id = id
    @dispenser_id = dispenser_id
    @opened_at = opened_at
    @closed_at = closed_at
    @flow_volume = flow_volume
    @total_spent = total_spent
    @created_at = created_at
    @updated_at = updated_at
  end
end
