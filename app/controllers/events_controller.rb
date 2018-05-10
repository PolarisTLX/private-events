class EventsController < ApplicationController

  # this is a filter to restrict access to only a user who is logged in.
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  # GET request
  def new
    @user = current_user
    @event = Event.new
  end

  # GET request
  def show
    @user = current_user
    @event = Event.find(params[:id])

    # need to store event to carry over to invite guests page:
    # need to store a cookie to do this
    session[:event_id] = @event.id
  end

  # POST request
  def create
    # @post = current_user.events.build(event_params)
    @event = current_user.hosted_events.build(event_params)

    if @event.save

      # # For the invites. Each user that has been checked off, need to send them an invite.
      # # The value is 1 when box is checked, 0 if empty.
      # params[:invite].each do |user_id, value|
      #   # make invite for user_id if value == 1
      #   next unless value == 1
      #   @invite = @event.invites.build(attendee_id: user_id)
      #   # Our events have 3 values:
      #   # -attended_event_id, (which is taken care of by "@event.invites.build")
      #   # -attendee_id
      #   # -accepted (which is defaulted to false)
      #   @invite.save
      # end

      flash[:success] = "Your event has been created!"
      redirect_to @event
    else
       render :new
    end
  end

  # GET request
  def edit
    @user = current_user
    @event = Event.find(params[:id])
  end

  # UPDATE request
  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      # handle successful update
      flash[:sucess] = "Event updated"
      redirect_to @event
    else
      render 'edit'
    end
  end

  # DELETE method
  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "Event deleted"
    redirect_to current_user
  end

  # GET method
  # to show all the events
  def index
    @user = current_user
    @events = Event.all
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :location, :date)
  end

  # This is the check to allow the authorisation of a user's access
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end
