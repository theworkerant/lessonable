class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :count
      t.datetime :start_date
      t.text :rules
      t.boolean :private

      t.timestamps
    end
  end
end
