class Api::V1::Dispensers::SpendingsController < ApplicationController
  def show
    input = Dispensers::GetSpendingInput.new(dispenser_params: permitted_params.to_h, requested_at: Time.current)
    dispenser_spending_entity = Dispensers::GetSpendingUseCase.new.perform(input: input)

    successful_response(dispenser_spending_entity)
  end

  private

  def permitted_params
    params.permit(:id)
  end

  def successful_response(spending_entity)
    super(DispenserSpendingSerializer.new(spending_entity))
  end
end
