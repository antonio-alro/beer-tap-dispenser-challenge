class RecordNotFoundError < BaseError
  def initialize(message: 'Record not found!', status: 404)
    super(message: message, status: status)
  end
end
