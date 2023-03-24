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

  describe '#find_in_progress_usage' do
    context 'when the record raises an exception' do
      it 'raises a NOT FOUND exception' do
        fake_record_klass = self.class::FakeExceptionUsageRecord

        expect { usage_repository.find_in_progress_usage(dispenser_id: 'id', record_klass: fake_record_klass) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the record does not raise an exception on create' do
      it 'return a dispenser entity instance' do
        opened_at = Time.current
        usage_record = UsageRecord.new(dispenser_id: 'dispenser_id', opened_at: opened_at, flow_volume: 0.055)
        fake_record_klass = self.class::FakeUsageRecord.with_usage(usage_record)
        fake_domain_factory = self.class::FakeDomainFactory

        expect(fake_record_klass).to receive(:find_by!).with(dispenser_id: 'dispenser_id', closed_at: nil).and_call_original

        expect(fake_domain_factory).to receive(:for).with(usage_record).and_call_original

        usage_repository.find_in_progress_usage(dispenser_id: 'dispenser_id', record_klass: fake_record_klass, domain_factory: fake_domain_factory)
      end
    end
  end

  describe '#update' do
    context 'when the record is not updated due to some errors' do
      it 'returns some errors' do
        fake_record_klass = self.class::FakeUpdateErrorsDispenserRecord
        fake_domain_factory = self.class::FakeDomainFactory

        expect(fake_record_klass).to receive(:find).with('1234').and_call_original

        output = usage_repository.update('1234', record_klass: fake_record_klass, domain_factory: fake_domain_factory, closed_at: Time.current)

        expect(output).to match({ usage: 'UsageEntity', errors: ['Error'] })
      end
    end

    context 'when the record is updated' do
      it 'does not return any errors' do
        fake_record_klass = self.class::FakeUpdatesuccessDispenserRecord
        fake_domain_factory = self.class::FakeDomainFactory

        expect(fake_record_klass).to receive(:find).with('1234').and_call_original

        output = usage_repository.update('1234', record_klass: fake_record_klass, domain_factory: fake_domain_factory, closed_at: Time.current)

        expect(output).to match({ usage: 'UsageEntity', errors: [] })
      end
    end
  end

  class self::FakeExceptionUsageRecord
    def self.create!(*)
      raise ActiveRecord::RecordInvalid
    end

    def self.find_by!(*)
      raise ActiveRecord::RecordNotFound
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

    def self.find_by!(*)
      @@usage
    end
  end

  class self::FakeUpdateErrorsDispenserRecord
    def initialize(*)
    end

    def self.find(*)
      new
    end

    def update(*)
      false
    end

    def errors
      ['Error']
    end
  end

  class self::FakeUpdatesuccessDispenserRecord
    def initialize(*)
    end

    def self.find(*)
      new
    end

    def update(*)
      true
    end

    def errors
      []
    end
  end

  class self::FakeDomainFactory
    def self.for(usage)
      'UsageEntity'
    end
  end
end
