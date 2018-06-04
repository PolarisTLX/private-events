class InvitesController < ApplicationController

  before_action :require_log_in, only: [:new, :create, :edit, :update, :destroy]

  def new
    @event = Event.find(params[:event_id])
    @invite = @event.invites.build
  end

  def create
    @event = Event.find(params[:event_id])
    #@event = Event.find(params[:invite][:event_id])
    unless params[:invite][:attendee].nil? # If no boxes are checked, just don't create any invites.
      params[:invite][:attendee].each do |i|
        invite = @event.invites.build(attendee_id: i.to_i)
        invite.save
      end
    end

    redirect_to @event
  end

  # GET action to flip the state of the accepted stated of the invite (perhaps should be update)
  def update
    @event = Event.find(params[:attended_event_id])
    #@user = User.find(params[:attendee_id])
    @invite = @event.invites.find_by(attendee_id: params[:attendee_id])
    @invite.update_columns(accepted: !@invite.accepted)
    redirect_to current_user
  end

end
