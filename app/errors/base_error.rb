class BaseError < StandardError
  attr_reader :message, :status

  def initialize(message:, status:)
    super
    @message = message
    @status = status
  end
end
