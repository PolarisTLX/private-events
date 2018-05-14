require 'rails_helper'
include SessionsHelper

RSpec.describe EventsController, type: :controller do
  before do
    Rails.application.load_seed
  end

  let(:user) { User.find_by(name: 'Person1') }

  context 'GET #new' do
    context 'when user is logged in but tries access new event page' do
      it 'successfully shows the new event page' do
        log_in(User.first)
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is NOT logged in but tries access new event page' do
      it 'redirects to login page' do
        # not logged in
        get :new
        expect(response).to redirect_to(login_url)
      end
    end
  end

  context 'POST #create' do
    # title: 'Something long enough', host_id: 1, description: 'Text goes here, I hope.', location: 'Somewhere', date: '2018-08-01'

    context 'when new event info is valid' do
      it 'creates the new event' do
        log_in(User.first)
        expect{post :create, params: { event: { title: 'Come to my party!', description: 'The next big event description', location: 'Somewhere Else', date: '2018-10-01', host_id: 1} }}.to change{Event.count}.by(1)
        # expect(response).to redirect_to(event_page)
      end
    end

    context 'when new event info is NOT invalid' do
      it 'does NOT create a new event' do
        log_in(User.first)
        # no description is provided
        expect{post :create, params: { event: { title: 'Come to my party!', description: '', location: 'Somewhere Else', date: '2018-10-01', host_id: 1} }}.to change{Event.count}.by(0)
      end
    end

    context 'when user is not logged in' do
      it 'event is not created and user is redirected to login page' do
        # log_in(User.first)
        expect{post :create, params: { event: { title: 'Come to my party!', description: '', location: 'Somewhere Else', date: '2018-10-01', host_id: 1} }}.to change{Event.count}.by(0)
        expect(response).to redirect_to(login_url)
      end
    end

    context 'when an event gets created' do
      # if @event.save
      #   @event.invites.create(attendee_id: current_user.id, accepted: true)

      it 'should also automatically create an accepted invite for the host' do
        log_in(User.first)
        expect{post :create, params: { event: { title: 'Come to my party!', description: 'It is gonna be a blast!', location: 'Somewhere Else', date: '2018-10-01', host_id: 1} }}.to change{Invite.count}.by(1)
      end
    end
  end
end
