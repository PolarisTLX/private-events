class InvitesController < ApplicationController

  # this is a filter to restrict access to only a user who is logged in.
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  # NOTE need to prepare a before_action if they don't come from an event page. redirect user

  # GET request
  def new
    @user = current_user # (needed for every GET request)

    # to show the event this is tied to
    @event = Event.find(session[:event_id])

    # this is same as @invite = Invite.new (but we are filling in the event_id)
    @invite = @event.invites.build
  end

  def create
    # this is to carry over the event that these invites will be associated with:
    @event = Event.find(session[:event_id])
    unless params[:invite].nil? # If no boxes are checked, just don't create any invites.
      params[:invite][:attendee].each do |i|
        invite = @event.invites.build(attendee_id: i.to_i)
        invite.save
      end
    end

    redirect_to @event
  end

  # GET action to flip the state of the accepted stated of the invite (perhaps should be update)
  def edit
    @event = Event.find(params[:attended_event_id])
    #@user = User.find(params[:attendee_id])
    @invite = @event.invites.find_by(attendee_id: params[:attendee_id])
    @invite.update_columns(accepted: !@invite.accepted)
    redirect_to current_user
  end


  private

  # This is the check to allow the authorisation of a user's access
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end
