class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.text :description
      # t.boolean :private
      t.boolean :template
      
      t.integer :duration
      t.integer :max_occupancy

      t.timestamps
    end
  end
end
