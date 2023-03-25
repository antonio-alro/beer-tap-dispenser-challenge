class DispenserSpendingSerializer < BaseSerializer
  def serializable_hash
    {
      'amount' => object.amount.round(3),
      'usages' => usages_serializable_hash
    }
  end

  private

  def usages_serializable_hash
    object.usages.map do |usage_entity|
      UsageSerializer.new(usage_entity).serializable_hash
    end
  end
end
