module Dispensers
  class UpdateStatusUseCaseFactory
    def self.for(status, dipsenser_entity: DispenserEntity, invalid_status_change_error: InvalidDispenserStatusChangeError)
      return Dispensers::OpenUseCase if status == dipsenser_entity::OPEN_STATUS
      return Dispensers::CloseUseCase if status == dipsenser_entity::CLOSE_STATUS

      raise invalid_status_change_error
    end
  end
end
