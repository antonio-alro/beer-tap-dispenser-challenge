module Usages
  class GetTotalSpentService
    REFERENCE_PRICE_PER_LITRE = 12.25

    def initialize(started_at:, ended_at:, flow_volume:)
      @started_at = started_at
      @ended_at = ended_at
      @flow_volume = flow_volume
    end

    def call
      return if started_at.nil? || ended_at.nil? || flow_volume.nil?

      total_spent.to_f
    end

    private

    attr_reader :started_at, :ended_at, :flow_volume

    def duration_in_seconds
      ended_at.to_time - started_at.to_time
    end

    def total_spent
      flow_volume * duration_in_seconds * REFERENCE_PRICE_PER_LITRE
    end
  end
end
