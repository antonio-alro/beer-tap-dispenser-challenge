require 'rails_helper'

RSpec.describe DispenserRecord do
  subject { create(:dispenser_record) }

  context 'associations' do
    it { is_expected.to have_many(:usages) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_inclusion_of(:status).in_array([DispenserRecord::OPEN_STATUS, DispenserRecord::CLOSE_STATUS]) }
    it { is_expected.to validate_presence_of(:flow_volume) }
    it { is_expected.to validate_numericality_of(:flow_volume).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:flow_volume).is_less_than(BigDecimal(10**4)) }
  end
end
