class ReservationsController < ApplicationController
  before_action :require_login

  def calendar
      @date = params[:date]&.to_date || Date.today
      @time_slots = TimeSlot.order(:start_time)
      @reservations_by_slot = current_user.reservations.where(date: @date)
                                          .includes(:time_slot, :table)
                                          .group_by(&:time_slot_id)
  end

  def index
    @reservations = current_user.reservations.includes(:time_slot, :table).upcoming
  end

  def confirmation
    @reservation = current_user.reservations.find(params[:id])
  end

  def new
    @reservation = Reservation.new
    @time_slots = TimeSlot.order(:start_time)
    @tables = Table.all
    @date = params[:date] || Date.today
    @time_slot_id = params[:time_slot_id]

    @available_tables = if @time_slot_id.present?
                          booked_table_ids = Reservation.where(
                            date: @date,
                            time_slot_id: @time_slot_id,
                            status: [:active, :pending]
                          ).pluck(:table_id)
                          Table.where.not(id: booked_table_ids)
                        else
                          Table.all
                        end
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.status ||= :active
    @time_slots = TimeSlot.order(:start_time)

    unless @reservation.time_slot
      flash.now[:alert] = "Please select a valid time slot."
      load_available_tables
      render :new, status: :unprocessable_entity
      return
    end

    reservation_time = Time.zone.parse("#{@reservation.date} #{@reservation.time_slot.start_time}")

    if reservation_time < 2.hours.from_now
      flash.now[:alert] = "Reservations must be made at least 2 hours in advance."
      load_available_tables
      render :new, status: :unprocessable_entity
      return
    end

    if reservation_available?(@reservation) && table_available?(@reservation)
      if @reservation.save
        redirect_to confirmation_reservation_path(@reservation)
      else
        load_available_tables
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Selected table is already booked for this time slot. Please choose another."
      load_available_tables
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation = current_user.reservations.find(params[:id])
    reservation_time = Time.zone.parse("#{@reservation.date} #{@reservation.time_slot.start_time}")

    if reservation_time > 2.hours.from_now
      @reservation.update(status: :cancelled)
      redirect_to reservations_path, notice: "Reservation cancelled."
    else
      redirect_to reservations_path, alert: "You can only cancel reservations 2 hours in advance."
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:date, :time_slot_id, :guest_count, :special_request, :table_id)
  end

  def reservation_available?(reservation)
    return false unless reservation.time_slot_id

    booked_count = Reservation.where(
      date: reservation.date,
      time_slot_id: reservation.time_slot_id,
      status: [:active]
    ).count

    booked_count < Table.count
  end

  # Reload @available_tables for the current date and time slot
  def load_available_tables
    if @reservation.time_slot_id.present? && @reservation.date.present?
      booked_table_ids = Reservation.where(
        date: @reservation.date,
        time_slot_id: @reservation.time_slot_id,
        status: [:active, :pending]
      ).pluck(:table_id)
      @available_tables = Table.where.not(id: booked_table_ids)
    else
      @available_tables = Table.all
    end
  end

    # Checks if the selected table is available for the given date and time slot
  def table_available?(reservation)
    return true unless reservation.table_id && reservation.date && reservation.time_slot_id

    Reservation.where(
      date: reservation.date,
      time_slot_id: reservation.time_slot_id,
      table_id: reservation.table_id,
      status: [:active, :pending]
    ).empty?
  end

end
