class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :redirect_admin_to_admin_dashboard, unless: :logout_action?
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

  def redirect_admin_to_admin_dashboard
    return unless current_user&.admin?
    unless request.path.start_with?("/admin")
      redirect_to admin_dashboard_path
    end
  end

  def logout_action?
    controller_name == "sessions" && action_name == "destroy"
  end
end
