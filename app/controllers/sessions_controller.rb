class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      if user.admin?
        redirect_to admin_dashboard_path, notice: "Welcome back, Admin!"
      else
        redirect_to reservations_path, notice: "Welcome back, #{user.name}!"
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Logged out successfully."
  end

  private

  def after_login_path_for(user)
    if user.admin?
      admin_dashboard_path
    else
      customer_home_path
    end
  end
end
