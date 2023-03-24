require 'rails_helper'

RSpec.describe DispenserRepository, type: :repository do
  subject(:dispenser_repository) { described_class }

  describe '#create' do
    context 'when the args are blank' do
      it 'returns nil' do
        expect(dispenser_repository.create()).to eq(nil)
      end
    end

    context 'when the record raises an exception on create' do
      it 'raises a custom exception' do
        fake_record_klass = self.class::FakeExceptionDispenserRecord

        expect { dispenser_repository.create(record_klass: fake_record_klass, flow_volume: 0.055) }
          .to raise_error(RepositoryError)
      end
    end

    context 'when the record does not raise an exception on create' do
      it 'creates a dispenser' do
        dispenser_record = DispenserRecord.new(flow_volume: 0.055, status: DispenserEntity::CLOSE_STATUS)
        fake_record_klass = self.class::FakeDispenserRecord.with_dispenser(dispenser_record)
        fake_domain_factory = self.class::FakeDomainFactory

        expect(fake_record_klass).to receive(:create!)
          .with({flow_volume: 0.055, status: DispenserEntity::CLOSE_STATUS})
          .and_call_original

        expect(fake_domain_factory).to receive(:for)
          .with(dispenser_record)
          .and_call_original

        dispenser_repository.create(record_klass: fake_record_klass, domain_factory: fake_domain_factory, flow_volume: 0.055)
      end
    end
  end

  describe '#find_by_id' do
    context 'when the record raises an exception on create' do
      it 'raises a NOT FOUND exception' do
        fake_record_klass = self.class::FakeExceptionDispenserRecord

        expect { dispenser_repository.find_by_id('id', record_klass: fake_record_klass) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the record does not raise an exception on create' do
      it 'return a dispenser entity instance' do
        dispenser_record = DispenserRecord.new(id: '1234', flow_volume: 0.055, status: DispenserEntity::CLOSE_STATUS)
        fake_record_klass = self.class::FakeDispenserRecord.with_dispenser(dispenser_record)
        fake_domain_factory = self.class::FakeDomainFactory

        expect(fake_record_klass).to receive(:find).with('1234').and_call_original

        expect(fake_domain_factory).to receive(:for).with(dispenser_record).and_call_original

        dispenser_repository.find_by_id('1234', record_klass: fake_record_klass, domain_factory: fake_domain_factory)
      end
    end
  end

  describe '#update' do
    context 'when the record is not updated due to some errors' do
      it 'returns some errors' do
        fake_record_klass = self.class::FakeUpdateErrorsDispenserRecord
        fake_domain_factory = self.class::FakeDomainFactory

        expect(fake_record_klass).to receive(:find).with('1234').and_call_original

        output = dispenser_repository.update('1234', record_klass: fake_record_klass, domain_factory: fake_domain_factory, status: 'open')

        expect(output).to match({ dispenser: 'DispenserEntity', errors: ['Error'] })
      end
    end

    context 'when the record is updated' do
      it 'does not return any errors' do
        fake_record_klass = self.class::FakeUpdatesuccessDispenserRecord
        fake_domain_factory = self.class::FakeDomainFactory

        expect(fake_record_klass).to receive(:find).with('1234').and_call_original

        output = dispenser_repository.update('1234', record_klass: fake_record_klass, domain_factory: fake_domain_factory, status: 'open')

        expect(output).to match({ dispenser: 'DispenserEntity', errors: [] })
      end
    end
  end

  class self::FakeExceptionDispenserRecord
    def self.create!(*)
      raise ActiveRecord::RecordInvalid
    end

    def self.find(*)
      raise ActiveRecord::RecordNotFound
    end
  end

  class self::FakeDispenserRecord
    attr_reader :dispenser

    def self.with_dispenser(dispenser)
      @@dispenser = dispenser
      self
    end

    def self.create!(*)
      @@dispenser
    end

    def self.find(*)
      @@dispenser
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
    def self.for(dispenser)
      'DispenserEntity'
    end
  end
end
