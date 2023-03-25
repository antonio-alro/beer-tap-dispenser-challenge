require 'rails_helper'

RSpec.describe Dispensers::UpdateStatusUseCaseFactory, type: :use_case do
  subject(:use_case_factory) { described_class }

  describe '#for' do
    context 'when the status is not expected' do
      it 'raises a custom error' do
        expect{
          use_case_factory.for('invalid_status', invalid_status_change_error: self.class::FakeError)
        }.to raise_error(self.class::FakeError)
      end
    end

    context 'when the status is expected' do
      expected_statuses = {
        'open' => Dispensers::OpenUseCase,
        'close' => Dispensers::CloseUseCase
      }

      expected_statuses.keys.each do |status|
        context "when the status is #{status}" do
          it 'return the expected class' do
            expected_class = expected_statuses[status]

            expect(use_case_factory.for(status)).to eq(expected_class)
          end
        end
      end
    end
  end

  class self::FakeError < BaseError
    def initialize(*)
    end
  end
end
