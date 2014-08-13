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
    user == self.current_user
  end

  def signed_in?
    !self.current_user.nil?
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def redirect_back_or(default)
    redirect_to( session[:return_to] || default )
    session.delete(:return_to)
  end

  def signed_in_user
    store_location
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end

end
