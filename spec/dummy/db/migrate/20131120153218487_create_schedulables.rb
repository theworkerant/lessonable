class CreateSchedulables < ActiveRecord::Migration
  def change
    create_table :schedulables do |t|
      t.integer :schedule_id
      t.integer :order
      t.references :schedulable, polymorphic: true

      t.timestamps
    end
  end
end