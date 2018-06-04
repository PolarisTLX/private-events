module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    log_in_from_remember_me_cookie if !session[:user_id] && cookies.signed[:user_id]
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def log_in_from_remember_me_cookie
    remembered_user = User.find_by(id: cookies.signed[:user_id])
    log_in(remembered_user) if remembered_user && remembered_user.check_remember_token?(cookies[:remember_token])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget(current_user)  # method is below
    session.delete(:user_id)
    @current_user = nil
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end



end
