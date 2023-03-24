class UsageRepository < BaseRepository
  def self.create(record_klass: UsageRecord, domain_factory: DomainFactories::UsageFactory, **args)
    usage_record = begin
      record_klass.create!(args)
    rescue ActiveRecord::RecordInvalid
      raise RepositoryError
    end

    domain_factory.for(usage_record)
  end
end
