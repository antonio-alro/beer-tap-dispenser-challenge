module Dispensers
  class CloseUseCase
    attr_reader :find_dispenser_service,
                :check_status_change_service,
                :use_case_error,
                :invalid_dispenser_status_change_error,
                :perform_close_service

    def initialize(find_dispenser_service: Dispensers::FindDispenserService,
                   check_status_change_service: Dispensers::CheckStatusChangeService,
                   use_case_error: UseCaseError,
                   invalid_dispenser_status_change_error: InvalidDispenserStatusChangeError,
                   perform_close_service: Dispensers::StatusChanges::PerformCloseService)
      @find_dispenser_service = find_dispenser_service
      @check_status_change_service = check_status_change_service
      @use_case_error = use_case_error
      @invalid_dispenser_status_change_error = invalid_dispenser_status_change_error
      @perform_close_service = perform_close_service
    end

    def perform(input:)
      dispenser = find_dispenser(input: input)

      raise use_case_error if dispenser.blank?
      raise invalid_dispenser_status_change_error if invalid_status_change?(dispenser: dispenser, input: input)

      # Ideally, this should be run as a background job.
      # You can see /jobs/dispensers/status_changes/perform_close_job.rb for further details
      # Dispensers::StatusChanges::PerformCloseJob.perform_later(dispenser.id, input.updated_at)
      perform_close_service.new(dispenser_id: dispenser.id, closed_at: input.updated_at).call

      true
    end

    private

    def find_dispenser(input:)
      find_dispenser_service.new(dispenser_id: input.dispenser_id).call
    end

    def invalid_status_change?(dispenser:, input:)
      check_status_change_service.new(current_status: dispenser.status, new_status: input.status).call == false
    end
  end
end
