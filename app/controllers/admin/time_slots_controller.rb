# app/controllers/admin/time_slots_controller.rb
class Admin::TimeSlotsController < ApplicationController
  before_action :require_admin
  before_action :set_time_slot, only: [:edit, :update, :destroy]

  def index
    @time_slots = TimeSlot.order(:start_time)
  end

  def new
    @time_slot = TimeSlot.new
  end

    # app/controllers/admin/time_slots_controller.rb
  def create
    @time_slot = TimeSlot.new(time_slot_params)
    if @time_slot.save
      redirect_to admin_time_slots_path, notice: "Time slot created successfully."
    else
      flash.now[:alert] = @time_slot.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @time_slot.update(time_slot_params)
      redirect_to admin_time_slots_path, notice: "Time slot updated successfully."
    else
      flash.now[:alert] = @time_slot.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @time_slot.destroy
    redirect_to admin_time_slots_path, notice: "Time slot deleted."
  end

  private

  def set_time_slot
    @time_slot = TimeSlot.find(params[:id])
  end

  def time_slot_params
    params.require(:time_slot).permit(:start_time, :end_time, :max_tables)
  end
end
