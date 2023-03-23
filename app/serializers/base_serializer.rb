class BaseSerializer
  def initialize(object)
    @object = object
  end

  def serializable_hash
    raise NotImplementedError
  end

  private

  attr_reader :object
end
