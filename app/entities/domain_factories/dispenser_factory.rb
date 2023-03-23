module DomainFactories
  class DispenserFactory
    def self.for(dispenser_record, domain_entity_klass: DispenserEntity)
      domain_entity_klass.new(
        id: dispenser_record.id,
        status: dispenser_record.status,
        flow_volume: dispenser_record.flow_volume,
        created_at: dispenser_record.created_at,
        updated_at: dispenser_record.updated_at
      )
    end
  end
end
