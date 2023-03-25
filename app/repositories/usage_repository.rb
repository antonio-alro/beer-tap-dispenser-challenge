class UsageRepository < BaseRepository
  def self.create(record_klass: UsageRecord, domain_factory: DomainFactories::UsageFactory, **args)
    usage_record = begin
      record_klass.create!(args)
    rescue ActiveRecord::RecordInvalid
      raise RepositoryError
    end

    domain_factory.for(usage_record)
  end

  def self.find_in_progress_usage(dispenser_id:, record_klass: UsageRecord, domain_factory: DomainFactories::UsageFactory)
    usage_record = record_klass.find_by!(dispenser_id: dispenser_id, closed_at: nil)

    domain_factory.for(usage_record)
  end

  def self.update(id, record_klass: UsageRecord, domain_factory: DomainFactories::UsageFactory, **args)
    usage_record = record_klass.find(id)
    usage_record.update(args)

    { usage: domain_factory.for(usage_record), errors: usage_record.errors }
  end

  def self.all_by_dispenser(dispenser_id:, record_klass: DispenserRecord, domain_factory: DomainFactories::UsageFactory)
    usage_records = begin
      record_klass.find(dispenser_id).usages.order(:created_at)
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFoundError
    end

    usage_records.map do |usage_record|
      domain_factory.for(usage_record)
    end
  end
end
