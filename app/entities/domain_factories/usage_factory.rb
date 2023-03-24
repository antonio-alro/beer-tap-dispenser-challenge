module DomainFactories
  class UsageFactory
    def self.for(usage_record, domain_entity_klass: UsageEntity)
      domain_entity_klass.new(
        id: usage_record.id,
        dispenser_id: usage_record.dispenser_id,
        opened_at: usage_record.opened_at,
        closed_at: usage_record.closed_at,
        flow_volume: usage_record.flow_volume,
        total_spent: usage_record.total_spent,
        created_at: usage_record.created_at,
        updated_at: usage_record.updated_at
      )
    end
  end
end
