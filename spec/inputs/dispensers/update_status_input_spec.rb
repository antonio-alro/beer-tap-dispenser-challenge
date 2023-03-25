require 'rails_helper'

RSpec.describe Dispensers::UpdateStatusInput, type: :input do
  subject(:input) { described_class.new(dispenser_params: params) }

  describe '#dispenser_id' do
    context 'when the dispenser params do not include the expected attribute id' do
      let(:params) do
        { other: 'other' }
      end

      it 'returns nil' do
        expect(input.dispenser_id).to eq(nil)
      end
    end

    context 'when the dispenser params include the expected attribute id' do
      let(:params) do
        { id: 'id' }
      end

      it 'returns the expected category id' do
        expect(input.dispenser_id).to eq('id')
      end
    end
  end

  describe '#status' do
    context 'when the dispenser params do not include the expected attribute status' do
      let(:params) do
        { other: 'other' }
      end

      it 'returns nil' do
        expect(input.status).to eq(nil)
      end
    end

    context 'when the dispenser params include the expected attribute status' do
      let(:params) do
        { status: 'open' }
      end

      it 'returns the expected category id' do
        expect(input.status).to eq('open')
      end
    end
  end

  describe '#updated_at' do
    context 'when the dispenser params do not include the expected attribute updated_at' do
      let(:params) do
        { other: 'other' }
      end

      it 'returns nil' do
        expect(input.updated_at).to eq(nil)
      end
    end

    context 'when the dispenser params include the expected attribute updated_at' do
      let(:params) do
        { updated_at: updated_at }
      end
      let(:updated_at) { '2022-01-01T02:00:00Z' }


      it 'returns the expected category id' do
        expect(input.updated_at).to eq(DateTime.parse(updated_at))
      end
    end
  end
end
