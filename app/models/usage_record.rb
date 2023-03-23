class UsageRecord < ApplicationRecord
  self.table_name = 'usages'
  self.implicit_order_column = "created_at"

  belongs_to :dispenser, class_name: 'DispenserRecord'

  validates :opened_at, presence: true
  validates :flow_volume, presence: true
end
