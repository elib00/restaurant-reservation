# app/controllers/admin/reservations_controller.rb
class Admin::ReservationsController < ApplicationController
  before_action :require_admin
  before_action :set_reservation, only: [:edit, :update, :destroy]

  def calendar
    @date = params[:date]&.to_date || Date.today
    @time_slots = TimeSlot.order(:start_time)
    @reservations_by_slot = Reservation.where(date: @date)
                                        .includes(:time_slot, :user, :table)
                                        .group_by(&:time_slot_id)
  end

  def index
    @reservations = Reservation.includes(:user, :table, :time_slot)
                               .order(date: :asc, time_slot_id: :asc)
  end

  def edit
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to admin_reservations_path, notice: "Reservation updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.update(status: :cancelled)
    redirect_to admin_reservations_path, notice: "Reservation cancelled."
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:date, :time_slot_id, :guest_count, :table_id, :special_request, :status)
  end
end
