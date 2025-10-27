class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :table, null: false, foreign_key: true
      t.date :date
      t.references :time_slot, null: false, foreign_key: true
      t.integer :guest_count
      t.text :special_request
      t.string :status

      t.timestamps
    end
  end
end
