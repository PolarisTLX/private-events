class UsersController < ApplicationController

  # GET action to show the new user sign-up page
  def new
    @user = User.new
  end

  # POST action to save a new created user from above
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Welcome to the Private Events app!"
      redirect_to @user
    end
  end

  # GET action to show the profile of an existing user
  def show
    @user = User.find(params[:id])
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


  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
