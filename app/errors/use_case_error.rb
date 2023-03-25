class UseCaseError < BaseError
  def initialize(message: 'Use case failed!', status: 500)
    super(message: message, status: status)
  end
end
