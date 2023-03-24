require 'rails_helper'

RSpec.describe Dispensers::CheckStatusChangeService, type: :service do
  subject(:service) { described_class.new(current_status: current_status, new_status: new_status) }

  context 'when new status is not present' do
    let(:current_status) { 'close' }
    let(:new_status) { nil }

    it 'returns false' do
      expect(service.call).to eq(false)
    end
  end

  context 'when new status is present' do
    context 'when current status and new status are the same' do
      let(:current_status) { 'close' }
      let(:new_status) { 'close' }

      it 'returns false' do
        expect(service.call).to eq(false)
      end
    end

    context 'when current status and new status are different' do
      let(:current_status) { 'close' }
      let(:new_status) { 'open' }

      it 'returns false' do
        expect(service.call).to eq(true)
      end
    end
  end
end
