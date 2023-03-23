class ApplicationController < ActionController::API
  rescue_from RepositoryError do |e|
    error_response(status: e.status)
  end

  private

  # Response when an error occurs at some point
  def error_response(status:)
    render json: '', status: status
  end

  # Response when a use case is successfully executed, including the serializable representation of given object
  def successful_response(object, status: :ok)
    render json: object.serializable_hash.to_json, status: status
  end
end
