require 'rails_helper'

RSpec.describe UsageRepository, type: :repository do
  subject(:usage_repository) { described_class }

  describe '#create' do
    context 'when the record raises an exception on create' do
      it 'raises a custom exception' do
        fake_record_klass = self.class::FakeExceptionUsageRecord

        expect {
          usage_repository.create(record_klass: fake_record_klass,
                                  dispenser_id: 'dispenser_id',
                                  opened_at: Time.current,
                                  flow_volume: 0.055)
        }.to raise_error(RepositoryError)
      end
    end

    context 'when the record does not raise an exception on create' do
      it 'creates a dispenser' do
        opened_at = Time.current
        usage_record = UsageRecord.new(dispenser_id: 'dispenser_id', opened_at: opened_at, flow_volume: 0.055)
        fake_record_klass = self.class::FakeUsageRecord.with_usage(usage_record)
        fake_domain_factory = self.class::FakeDomainFactory

        expect(fake_record_klass).to receive(:create!)
          .with({dispenser_id: 'dispenser_id', opened_at: opened_at, flow_volume: 0.055 })
          .and_call_original

        expect(fake_domain_factory).to receive(:for)
          .with(usage_record)
          .and_call_original

        usage_repository.create(record_klass: fake_record_klass,
                                domain_factory: fake_domain_factory,
                                dispenser_id: 'dispenser_id',
                                opened_at: opened_at,
                                flow_volume: 0.055)
      end
    end
  end

  class self::FakeExceptionUsageRecord
    def self.create!(*)
      raise ActiveRecord::RecordInvalid
    end
  end

  class self::FakeUsageRecord
    attr_reader :usage

    def self.with_usage(usage)
      @@usage = usage
      self
    end

    def self.create!(*)
      @@usage
    end
  end

  class self::FakeDomainFactory
    def self.for(usage)
      'UsageEntity'
    end
  end
end
