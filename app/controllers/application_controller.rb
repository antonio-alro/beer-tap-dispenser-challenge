class ApplicationController < ActionController::API
  rescue_from RepositoryError do |e|
    error_response(status: e.status)
  end

  rescue_from RecordNotFoundError do |e|
    error_response(status: e.status)
  end

  rescue_from InvalidDispenserStatusChangeError do |e|
    error_response(status: e.status)
  end

  private

  def api_response(response_data, status:)
    render json: response_data, status: status
  end

  # Response when an error occurs at some point
  def error_response(status:)
    api_response('', status: status)
  end

  # Response when a use case is successfully executed, including the serializable representation of given object
  def successful_response(object, status: :ok)
    api_response(object.serializable_hash.to_json, status: status)
  end
end
