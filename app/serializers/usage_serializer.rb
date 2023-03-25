class UsageSerializer < BaseSerializer
  def serializable_hash
    serialized_hash = object.as_json.slice('opened_at', 'closed_at', 'flow_volume', 'total_spent')

    serialized_hash['total_spent'] = object.estimated_total_spent.round(3) if serialized_hash['total_spent'].blank?

    serialized_hash
  end
end
