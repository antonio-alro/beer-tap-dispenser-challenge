class Api::V1::Dispensers::StatusesController < ApplicationController
  def update
    input = Dispensers::UpdateStatusInput.new(dispenser_params: on_update_permitted_params.to_h)

    use_case_klass = Dispensers::UpdateStatusUseCaseFactory.for(input.status)

    use_case_klass.new.perform(input: input)

    succesful_empty_response
  end

  private

  def on_update_permitted_params
    params.permit(:id, :status, :updated_at)
  end

  def succesful_empty_response
    api_response('', status: :accepted)
  end
end
