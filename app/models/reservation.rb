class Reservation < ApplicationRecord
  belongs_to :room

  validates :reservation_duration, presence: true

  validate :validate_check_out_after_check_in

  validate :validate_room_available

  validate :validate_guest_count

  before_save :calculate_total_price

  def check_in
    reservation_duration.first if reservation_duration.present?
  end

  def check_out
    reservation_duration.last if reservation_duration.present?
  end

  def validate_check_out_after_check_in
    if check_out <= check_in
      errors.add(:base, "Check-out must be later than check-in.")
    end
  end

  def validate_room_available
    reservations = Reservation.where(cancelled: false, room_id: room.id)

    if overlapping_days.any?
      errors.add(:base, "The room is not available.")
    end
  end

  def overlapping_days
    reservations = Reservation.where(cancelled: false, room_id: room.id)

    reservations.select {|r| reservation_duration.overlaps? r.reservation_duration}.map{|r| r.reservation_duration.first.to_date..r.reservation_duration.last.to_date}.map{|r| r.to_a}.flatten
  end

  def calculate_total_price

    weekdays, weekends = reservation_duration.partition(&:on_weekday?)
    self.total_price = (weekdays.count * room.weekday_rate) + (weekends.count * room.weekend_rate)
  end

  def as_json(options={})
    super.as_json(options).merge(total_price: total_price.to_f)
  end

  def validate_guest_count
    unless guest_count <= room.max_guests
      errors.add(:guest_count, "Less people please!!")
    end
  end

end
