class Api::V1::DispensersController < ApplicationController
  def create
    input = Dispensers::CreateDispenserInput.new(dispenser_params: on_create_permitted_params.to_h)
    dispenser_entity = Dispensers::CreateDispenserUseCase.new.perform(input: input)

    successful_response(dispenser_entity)
  end

  private

  def on_create_permitted_params
    params.permit(:flow_volume)
  end

  def successful_response(dispenser_entity)
    super(DispenserSerializer.new(dispenser_entity))
  end
end
