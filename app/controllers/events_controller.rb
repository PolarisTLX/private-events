class EventsController < ApplicationController

  # this is a filter to restrict access to only a user who is logged in.
  before_action :logged_in_user, only: [:new, :show, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET request
  def new
    @user = current_user
    @event = Event.new
  end

  # GET request
  def show
    @user = current_user
    @event = Event.find(params[:id])
    @attendees = @event.attendees.where("invites.accepted = ?", true)
    @invited = @event.attendees.where("invites.accepted = ?", false)
    # need to store event to carry over to invite guests page:
    # need to store a cookie to do this
    session[:event_id] = @event.id
  end

  # POST request
  def create
    # @post = current_user.events.build(event_params)
    @event = current_user.hosted_events.build(event_params)

    if @event.save
      @event.invites.create(attendee_id: current_user.id, accepted: true)
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
      flash[:success] = "Event updated"
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
    # @events = Event.all
    @past_events = Event.past
    @upcoming_events = Event.upcoming
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

  def correct_user
    @event = Event.find(params[:id])
    @user = User.find(@event.host_id)
    redirect_to(current_user) unless @user == current_user
    # this sends a user to their own page if they try to access a different profile
  end

end
