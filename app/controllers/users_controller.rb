class UsersController < ApplicationController

  # filter to redirect user to log-in page if they are not yet logged in and they are trying to access the edit or update
  before_action :logged_in_user, only: [:edit, :update]

  # filter to give specific access to each user
  before_action :correct_user, only: [:edit, :update]

  # GET action to show the new user sign-up page
  def new
    @user = User.new
  end

  # POST action to save a new created user from above
  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Private Events app!'
      redirect_to @user
    end
  end

  # GET action to show the profile of an existing user
  def show
    @user = User.find(params[:id])
    @invites = @user.attended_events.where("invites.accepted = ?", false).upcoming
    #@past_events = @user.attended_events.where("date < ?", Date.today).order(date: "DESC")
    @past_events = @user.attended_events.past
    # @upcoming_events = @user.attended_events.where("invites.accepted = ?", true)
    #                                         .where("date >= ?", Date.today)
    @upcoming_events = @user.attended_events.where("invites.accepted = ?", true).upcoming
  end

  # GET action to show the user edit page
  def edit
    @user = User.find(params[:id])
  end

  # POST action to save the edits to a user
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Authorisation to control which logged-in user can see what
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(current_user) unless @user == current_user
    # this sends a user to their own page if they try to access a different profile
  end

end
