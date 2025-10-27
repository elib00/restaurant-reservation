module Admin
  class DashboardController < ApplicationController
    before_action :require_admin

    def index
      @view = params[:view] || "daily" # default view
      today = Date.today

      case @view
      when "daily"
        @reservations = Reservation.includes(:user, :table, :time_slot)
                                  .where(date: today)
                                  .order(:time_slot_id)
      when "weekly"
        week_start = today.beginning_of_week
        week_end   = today.end_of_week
        @reservations = Reservation.includes(:user, :table, :time_slot)
                                  .where(date: week_start..week_end)
                                  .order(:date, :time_slot_id)
      when "monthly"
        month_start = today.beginning_of_month
        month_end   = today.end_of_month
        @reservations = Reservation.includes(:user, :table, :time_slot)
                                  .where(date: month_start..month_end)
                                  .order(:date, :time_slot_id)
      else
        @reservations = Reservation.none
      end
    end

    private

    def require_admin
      redirect_to root_path, alert: "Access denied." unless current_user&.admin?
    end
  end
end
