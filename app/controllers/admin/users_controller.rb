module Admin
  class UsersController < ApplicationController
    before_action :require_admin

    def index
      # Exclude the currently logged-in admin
      @users = User.where.not(id: current_user.id)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "User updated successfully"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: "User deleted"
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :contact_number, :role)
    end
  end
end
