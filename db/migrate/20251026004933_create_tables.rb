class CreateTables < ActiveRecord::Migration[7.1]
  def change
    create_table :tables do |t|
      t.string :name
      t.integer :capacity
      t.string :location
      t.string :shape
      t.text :description

      t.timestamps
    end
  end
end
