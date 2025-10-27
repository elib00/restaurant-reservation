class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user
  layout :determine_layout

  private
    
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    redirect_to login_path, alert: "Please log in" unless current_user
  end

  def determine_layout
    current_user&.admin? ? "admin" : "application"
  end
end
