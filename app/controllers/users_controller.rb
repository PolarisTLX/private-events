class UsersController < ApplicationController

  before_action :require_log_in, only: [:edit, :update]

  before_action :check_correct_user, only: [:edit, :update]
  before_action :require_logged_out, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Private Events app!'
      redirect_to @user
    else
      render 'new'
    end
  end

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

end
