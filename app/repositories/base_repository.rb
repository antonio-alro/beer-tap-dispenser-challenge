class BaseRepository
  def self.execute_as_transaction(record_base_klass: ActiveRecord::Base)
    record_base_klass.transaction do
      yield
    end
  end
end
