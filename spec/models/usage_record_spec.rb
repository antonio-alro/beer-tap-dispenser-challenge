require 'rails_helper'

RSpec.describe DispenserRecord do
  subject { create(:usage_record) }

  context 'associations' do
    it { is_expected.to belong_to(:dispenser) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:opened_at) }
    it { is_expected.to validate_presence_of(:flow_volume) }
  end
end
