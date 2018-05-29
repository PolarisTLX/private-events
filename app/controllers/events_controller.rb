class EventsController < ApplicationController

  before_action :require_log_in, only: [:new, :show, :create, :edit, :update, :destroy]
  before_action :check_correct_user, only: [:edit, :update, :destroy]

  def new
    @event = Event.new
  end

  def show
    @attendees = event.attendees.where("invites.accepted = ?", true)
    @invited = event.attendees.where("invites.accepted = ?", false)
  end

  def create
    @event = current_user.hosted_events.build(event_params)

    if @event.save
      flash[:success] = "Your event has been created!"
      redirect_to @event
    else
       render :new
    end
  end

  def edit
    event
  end

  def update
    if event.update_attributes(event_params)
      flash[:success] = "Event updated"
      redirect_to event
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

  def event
    @event ||= Event.find(params[:id])
  end

end
