require 'rails_helper'

RSpec.describe Dispensers::GetSpendingInput, type: :input do
  subject(:input) { described_class.new(dispenser_params: params, requested_at: requested_at) }

  let(:params) do
    { dispenser_id: 'fake_id' }
  end
  let(:requested_at) { Time.current }

  describe '#requested_at' do
    it 'returns the expected requested_at' do
      expect(input.requested_at).to eq(requested_at)
    end
  end

  describe '#dispenser_id' do
    context 'when the dispenser params do not include the expected attribute dispenser_id' do
      let(:params) do
        { other: 'other' }
      end

      it 'returns nil' do
        expect(input.dispenser_id).to eq(nil)
      end
    end

    context 'when the dispenser params include the expected attribute dispenser_id' do
      let(:params) do
        { id: 'fake_id' }
      end

      it 'returns the expected category id' do
        expect(input.dispenser_id).to eq('fake_id')
      end
    end
  end
end
