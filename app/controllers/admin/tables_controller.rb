class Admin::TablesController < ApplicationController
  before_action :require_admin
  before_action :set_table, only: [:edit, :update, :destroy]

  def index
    @tables = Table.order(:name)
  end

  def new
    @table = Table.new
  end

  def create
    @table = Table.new(table_params)
    if @table.save
      redirect_to admin_tables_path, notice: "Table created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @table.update(table_params)
      redirect_to admin_tables_path, notice: "Table updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @table.destroy
    redirect_to admin_tables_path, notice: "Table deleted."
  end

  private

  def set_table
    @table = Table.find(params[:id])
  end

  def table_params
    params.require(:table).permit(:name, :capacity, :location, :shape, :description)
  end
end
