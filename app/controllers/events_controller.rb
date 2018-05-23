class EventsController < ApplicationController

  # this is a filter to restrict access to only a user who is logged in.
  before_action :require_log_in, only: [:new, :show, :create, :edit, :update, :destroy]
  before_action :check_correct_user, only: [:edit, :update, :destroy]

  # GET request
  def new
    @event = Event.new
  end

  # GET request
  def show
    @event = Event.find(params[:id])
    @attendees = @event.attendees.where("invites.accepted = ?", true)
    @invited = @event.attendees.where("invites.accepted = ?", false)
    # need to store event to carry over to invite guests page:
    # need to store a cookie to do this
    # session[:event_id] = @event.id
  end

  # POST request
  def create
    @event = current_user.hosted_events.build(event_params)

    if @event.save
      flash[:success] = "Your event has been created!"
      redirect_to @event
    else
       render :new
    end
  end

  # GET request
  def edit
    find_event
  end

  # UPDATE request
  def update
    find_event
    if @event.update_attributes(event_params)
      # handle successful update
      flash[:success] = "Event updated"
      redirect_to @event
    else
      render 'edit'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "Event deleted"
    redirect_to current_user
  end

  def index
    @past_events = Event.past
    @upcoming_events = Event.upcoming
  end


  private

  def event_params
    params.require(:event).permit(:title, :description, :location, :date)
  end

  def find_event
    @event ||= Event.find(params[:id])
  end

end
