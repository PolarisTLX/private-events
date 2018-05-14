require 'rails_helper'
include SessionsHelper

RSpec.describe InvitesController, type: :controller do

  before do
    Rails.application.load_seed
  end

  let(:user) { User.find_by(name: 'Person1') }
  let(:event) { Event.find_by(title: 'This is the 3rd event') }

  context 'GET #new' do
    context 'when user is logged in and tries access new invite page' do
      it 'successfully shows the new invite page' do
        session[:event_id] = event.id
        log_in(user)
        get :new
        expect(response).to have_http_status(:success)
      end
    end
    context 'when user is NOT logged in but tries access new invite page' do
      it 'redirects to login page' do
        session[:event_id] = event.id
        # not logged in
        get :new
        expect(response).to redirect_to(login_url)
      end
    end
  end

  context 'POST #create' do
    # title: 'Something long enough', host_id: 1, description: 'Text goes here, I hope.', location: 'Somewhere', date: '2018-08-01'

    context 'when new invite info is valid' do
      it 'creates the new invite and redirects back to event page' do
        log_in(user)
        session[:event_id] = event.id
        expect { post :create, params: { invite: { attendee: [1, 2] } } }.to change{Invite.count}.by(2)
        expect(response).to redirect_to(event)
      end
    end

    context 'when new invite info is NOT invalid' do
      it 'does NOT create a new invite' do
        log_in(user)
        session[:event_id] = event.id
        expect { post :create, params: { invite: { attendee: [3] } } }.to change{Invite.count}.by(0)
      end
    end

    context 'when user is not logged in' do
      it 'invite is not created and user is redirected to login page' do
        session[:event_id] = event.id
        expect { post :create, params: { invite: { attendee: [2] } } }.to change{Invite.count}.by(0)
        expect(response).to redirect_to(login_url)
      end
    end
  end

  context 'GET #edit' do
    context 'when user accepts an invite' do
      it 'updates the "accepted" status of the invite' do
        log_in(user)
        # @invite = @event.invites.find_by(attendee_id: params[:attendee_id])
        invite = user.invites.where(accepted: false).first
        expect { get :edit, params: { id: invite.id, attended_event_id: invite.attended_event_id, attendee_id: user.id } }.to change { user.invites.where(accepted: false).count }.by(-1)
        # expect(invite.accepted)
      end
    end
  end

end
