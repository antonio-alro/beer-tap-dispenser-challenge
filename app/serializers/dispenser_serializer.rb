class DispenserSerializer < BaseSerializer
  def serializable_hash
    object.as_json.slice('id', 'flow_volume')
  end
end
