class DispenserEntity
  OPEN_STATUS = 'open'.freeze
  CLOSE_STATUS = 'close'.freeze

  attr_reader :id, :status, :flow_volume, :created_at, :updated_at

  def initialize(id:, status:, flow_volume:, created_at:, updated_at:)
    @id = id
    @status = status
    @flow_volume = flow_volume
    @created_at = created_at
    @updated_at = updated_at
  end
end
