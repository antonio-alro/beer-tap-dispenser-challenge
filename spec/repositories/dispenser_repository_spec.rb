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
        dispenser_record = DispenserRecord.new(flow_volume: 0.055, status: DispenserRecord::CLOSE_STATUS)
        fake_record_klass = self.class::FakeDispenserRecord.with_dispenser(dispenser_record)
        fake_domain_factory = self.class::FakeDomainFactory

        expect(fake_record_klass).to receive(:create!)
          .with({flow_volume: 0.055, status: DispenserRecord::CLOSE_STATUS})
          .and_call_original

        expect(fake_domain_factory).to receive(:for)
          .with(dispenser_record)
          .and_call_original

        dispenser_repository.create(record_klass: fake_record_klass, domain_factory: fake_domain_factory, flow_volume: 0.055)
      end
    end
  end

  class self::FakeExceptionDispenserRecord
    CLOSE_STATUS = 'close'

    def self.create!(*)
      raise ActiveRecord::RecordInvalid
    end
  end

  class self::FakeDispenserRecord
    CLOSE_STATUS = 'close'

    attr_reader :dispenser

    def self.with_dispenser(dispenser)
      @@dispenser = dispenser
      self
    end

    def self.create!(*)
      @@dispenser
    end
  end

  class self::FakeDomainFactory
    def self.for(dispenser)
      'DispenserEntity'
    end
  end
end
