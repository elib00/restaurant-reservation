module Admin
  class ReservationsController < ApplicationController
    before_action :require_admin

    def index
      @reservations = Reservation.all.order(created_at: :desc)
    end

    def edit
      @reservation = Reservation.find(params[:id])
    end

    def update
      @reservation = Reservation.find(params[:id])
      if @reservation.update(reservation_params)
        redirect_to admin_reservations_path, notice: "Reservation updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @reservation = Reservation.find(params[:id])
      @reservation.destroy
      redirect_to admin_reservations_path, notice: "Reservation deleted successfully."
    end

    private

    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :party_size, :date, :time, :status)
    end

    def require_admin
      unless current_user&.admin?
        redirect_to root_path, alert: "Access denied."
      end
    end
  end
end
