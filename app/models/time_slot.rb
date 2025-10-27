class TimeSlot < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :tables, through: :reservations

  validates :start_time, :end_time, :max_tables, presence: true
  validate :no_overlap
  validate :valid_time_range

  def available_tables
    Table.where.not(id: reservations.pluck(:table_id))
  end

  def formatted_range
    "#{start_time.strftime("%I:%M %p")} - #{end_time.strftime("%I:%M %p")}"
  end

  private

  def valid_time_range
    errors.add(:end_time, "must be after start time") if end_time <= start_time
  end

  def no_overlap
    # Get all other time slots
    other_slots = TimeSlot.where.not(id: id)

    overlapping = other_slots.any? do |slot|
      (start_time < slot.end_time) && (end_time > slot.start_time)
    end

    if overlapping
      errors.add(:base, "This time slot overlaps with an existing time slot")
    end
  end
end
