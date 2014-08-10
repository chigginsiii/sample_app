module SessionsHelper

  def sign_in(user)
    token = User.new_remember_token
    cookies.permanent[:remember_token] = token
    user.update_attribute( :remember_token, User.digest(token) )
    self.current_user = user
  end

  def sign_out
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
    token_hash = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(:remember_token => token_hash)
  end

  def signed_in?
    !current_user.nil?
  end

end
