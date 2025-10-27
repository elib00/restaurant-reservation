class AdminConstraint
  def self.matches?(request)
    user_id = request.session[:user_id]
    user = User.find_by(id: user_id)
    user && user.admin?
  end
end
