class CreateDispensers < ActiveRecord::Migration[7.0]
  def change
    create_table :dispensers, id: :uuid do |t|
      t.string :status, limit: 15, null: false
      t.decimal :flow_volume, precision: 10, scale: 6, null: false
      t.timestamps
    end

    add_index :dispensers, :created_at
  end
end
