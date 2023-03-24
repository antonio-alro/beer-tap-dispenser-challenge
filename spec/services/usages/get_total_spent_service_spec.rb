require 'rails_helper'

RSpec.describe Usages::GetTotalSpentService, type: :service do
  subject(:service) { described_class.new(started_at: started_at, ended_at: ended_at, flow_volume: flow_volume) }

  let(:started_at) { DateTime.parse('2022-01-01T02:50:58Z') }
  let(:ended_at) { DateTime.parse('2022-01-01T02:51:20Z') }
  let(:flow_volume) { 0.064 }

  context 'when started_at is not present' do
    let(:started_at) { nil }

    it 'returns nil' do
      expect(service.call).to eq(nil)
    end
  end

  context 'when ended_at is not present' do
    let(:ended_at) { nil }

    it 'returns nil' do
      expect(service.call).to eq(nil)
    end
  end

  context 'when flow_volume is not present' do
    let(:flow_volume) { nil }

    it 'returns nil' do
      expect(service.call).to eq(nil)
    end
  end

  it 'returns the expected amount spent' do
    expect(service.call).to eq(17.247999999999998)
  end
end
