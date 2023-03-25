# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def create_dispenser(flow_volume:, status: nil)
  DispenserRepository.create(flow_volume: flow_volume, status: status)
end

def create_usage(dispenser_id:, opened_at:, closed_at:, flow_volume:, total_spent:)
  UsageRepository.create(
    dispenser_id: dispenser_id,
    opened_at: opened_at,
    closed_at: closed_at,
    flow_volume: flow_volume,
    total_spent: total_spent
  )
end

dispenser = create_dispenser(flow_volume: 0.064)

usages_data = [
  {
    opened_at: "2022-01-01T02:00:00Z",
    closed_at: "2022-01-01T02:00:50Z",
    flow_volume: 0.064,
    total_spent: 39.2
  },
  {
    opened_at: "2022-01-01T02:50:58Z",
    closed_at: "2022-01-01T02:51:20Z",
    flow_volume: 0.064,
    total_spent: 17.248
  },
  {
    opened_at: "2022-01-01T13:50:58Z",
    closed_at: nil,
    flow_volume: 0.064,
    total_spent: nil
  }
]

usages_data.each do |usage_data|
  create_usage(
    dispenser_id: dispenser.id,
    opened_at: usage_data[:opened_at],
    closed_at: usage_data[:closed_at],
    flow_volume: usage_data[:flow_volume],
    total_spent: usage_data[:total_spent]
  )
end
