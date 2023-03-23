class RepositoryError < BaseError
  def initialize(message: 'Repository failed!', status: 500)
    super(message: message, status: status)
  end
end
