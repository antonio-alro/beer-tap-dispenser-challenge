FactoryBot.define do
  factory :dispenser_record do
    status { 'close' }
    flow_volume { 0.0050 }

    trait :open do
      status { 'open' }
    end

    trait :close do
      status { 'close' }
    end
  end
end
