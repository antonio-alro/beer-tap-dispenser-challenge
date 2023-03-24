class InvalidDispenserStatusChangeError < BaseError
  def initialize(message: 'Invalid dispenser status change!', status: 409)
    super(message: message, status: status)
  end
end
