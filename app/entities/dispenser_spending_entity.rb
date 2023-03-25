class DispenserSpendingEntity
  attr_reader :usages

  def initialize(usages:)
    @usages = usages
  end

  def amount
    usages.sum do |usage|
      (usage.total_spent.present? ? usage.total_spent : usage.estimated_total_spent).to_f
    end
  end
end
