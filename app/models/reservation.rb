class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :table, optional: true
  belongs_to :time_slot

  validates :guest_count, presence: true, numericality: { greater_than: 0 }
  validates :date, :time_slot_id, :guest_count, presence: true
  validate :date_cannot_be_in_the_past
  validate :must_be_two_hours_before
  validate :table_not_double_booked, on: :create

  enum status: { active: "active", cancelled: "cancelled" }

  scope :upcoming, -> { where("date >= ?", Date.today).order(date: :asc) }

  # Set default status to 'active' for new reservations 
  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= "active"
  end

  def date_cannot_be_in_the_past
    errors.add(:date, "can’t be in the past") if date.present? && date < Date.today
  end

  def must_be_two_hours_before
    return unless date && time_slot

    reservation_time = Time.zone.parse("#{date} #{time_slot.start_time}")
    if reservation_time < 2.hours.from_now
      errors.add(:base, "Reservations must be made at least 2 hours in advance")
    end
  end

  def table_not_double_booked
    return unless table_id && date && time_slot_id

    if Reservation.where(
      date: date,
      time_slot_id: time_slot_id,
      table_id: table_id,
      status: [:active, :pending]
    ).exists?
      errors.add(:table_id, "is already booked for this time slot")
    end
  end
end
