class DispenserRepository
  def self.create(record_klass: DispenserRecord, domain_factory: DomainFactories::DispenserFactory, **args)
    return if args.blank?

    dispenser_record = begin
      record_klass.create!(args.merge({status: record_klass::CLOSE_STATUS}))
    rescue ActiveRecord::RecordInvalid
      raise RepositoryError
    end

    domain_factory.for(dispenser_record)
  end
end
