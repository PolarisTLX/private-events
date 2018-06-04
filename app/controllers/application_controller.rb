class ApplicationController < ActionController::Base
  include SessionsHelper

  def require_log_in
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def require_logged_out
    if logged_in?
      redirect_to current_user
    end
  end

  def check_correct_user
    @user = User.find(params[:id])
    redirect_to(current_user) unless @user == current_user
    # this sends a user to their own page if they try to access a different profile
  end
end
