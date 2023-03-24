class DispenserRepository < BaseRepository
  def self.create(record_klass: DispenserRecord,
                  domain_factory: DomainFactories::DispenserFactory,
                  domain_entity: DispenserEntity,
                  **args)
    return if args.blank?

    dispenser_record = begin
      record_klass.create!(args.merge({status: DispenserEntity::CLOSE_STATUS}))
    rescue ActiveRecord::RecordInvalid
      raise RepositoryError
    end

    domain_factory.for(dispenser_record)
  end

  def self.find_by_id(id, record_klass: DispenserRecord, domain_factory: DomainFactories::DispenserFactory)
    dispenser_record = record_klass.find(id)

    domain_factory.for(dispenser_record)
  end

  def self.update(id, record_klass: DispenserRecord, domain_factory: DomainFactories::DispenserFactory, **args)
    dispenser_record = record_klass.find(id)
    dispenser_record.update(args)

    { dispenser: domain_factory.for(dispenser_record), errors: dispenser_record.errors }
  end
end
