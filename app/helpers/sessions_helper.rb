module SessionsHelper

  def sign_in(user)
    token = User.new_remember_token
    cookies.permanent[:remember_token] = token
    user.update_attribute( :remember_token, User.digest(token) )
    self.current_user = user
  end

  def sign_out
    return unless current_user
    current_user.update_attribute( :remember_token, User.digest(User.new_remember_token) )
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  # this splits the attr_accessor into a regular assignment
  # setter, and a cookie/session-aware getter
  def current_user=(user)
    @current_user = user
  end

  def current_user
    cookie_token = cookies[:remember_token]
    this_user    = @current_user
    @current_user ||= User.find_by_remember_token( User.digest( cookies[:remember_token] ) )
  end

  def current_user?(user)
    result = ( user == self.current_user )
    result
  end

  def signed_in?
    signed_in = !self.current_user.nil?
    signed_in
  end

end
