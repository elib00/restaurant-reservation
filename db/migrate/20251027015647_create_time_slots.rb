class CreateTimeSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :time_slots do |t|
      t.time :start_time
      t.time :end_time
      t.integer :max_tables

      t.timestamps
    end
  end
end
