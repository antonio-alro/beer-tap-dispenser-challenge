require 'rails_helper'

RSpec.describe Dispensers::CreateDispenserInput, type: :input do
  subject(:input) { described_class.new(dispenser_params: params) }

  describe '#flow_volume' do
    context 'when the dispenser params do not include the expected attribute flow_volume' do
      let(:params) do
        { other: 'other' }
      end

      it 'returns nil' do
        expect(input.flow_volume).to eq(nil)
      end
    end

    context 'when the dispenser params include the expected attribute flow_volume' do
      let(:params) do
        { flow_volume: 0.057 }
      end

      it 'returns the expected flow_volume' do
        expect(input.flow_volume).to eq(0.057)
      end
    end
  end
end
