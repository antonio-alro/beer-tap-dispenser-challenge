class DispenserRecord < ApplicationRecord
  self.table_name = 'dispensers'
  self.implicit_order_column = "created_at"

  OPEN_STATUS = 'open'
  CLOSE_STATUS = 'close'

  has_many :usages, class_name: 'UsageRecord', foreign_key: 'dispenser_id', dependent: :destroy

  validates :status, presence: true, inclusion: { in: [OPEN_STATUS, CLOSE_STATUS] }
  validates :flow_volume, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: BigDecimal(10**4) }
end
