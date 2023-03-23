FactoryBot.define do
  factory :usage_record do
    dispenser { build(:dispenser_record) }
    flow_volume { 0.0050 }
    opened_at { Time.current - 60.seconds }
    closed_at { Time.current }
  end
end
