class Table < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :location, presence: true
  validates :shape, presence: true
end


