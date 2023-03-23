class CreateUsages < ActiveRecord::Migration[7.0]
  def change
    create_table :usages, id: :uuid do |t|
      t.uuid :dispenser_id
      t.datetime :opened_at, null: false
      t.datetime :closed_at
      t.decimal :flow_volume, precision: 10, scale: 6, null: false
      t.decimal :total_spent, precision: 10, scale: 2
      t.timestamps
    end

    add_index :usages, :dispenser_id
    add_index :usages, :closed_at
    add_index :usages, :created_at
  end
end
