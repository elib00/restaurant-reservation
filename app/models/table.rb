class Table < ApplicationRecord
  validates :name, :capacity, :location, :shape, :description, presence: true
  validates :capacity, numericality: { greater_than: 0 }
end
