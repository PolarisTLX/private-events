require 'rails_helper'
include SessionsHelper

RSpec.describe EventsController, type: :controller do

  before do
    Rails.application.load_seed
  end

  let(:user) { User.find_by(name: 'Person1') }

  context 'when user is logged in' do

  before { log_in(User.first) }

  describe 'GET #new' do
      it 'successfully shows the new event page' do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST #create' do
      describe 'when new event info is valid' do
        it 'creates the new event' do
          expect{post :create, params: { event: { title: 'Come to my party!', description: 'The next big event description', location: 'Somewhere Else', date: '2018-10-01', host_id: 1} }}.to change{Event.count}.by(1)
          expect(Event.last.invites.count).to eql(1)
          expect(Event.last.title).to eq 'Come to my party!'
          expect(response).to redirect_to(Event.last)
        end
      end

      describe 'when new event info is NOT invalid' do
        it 'does NOT create a new event' do
          expect{post :create, params: { event: { title: 'Come to my party!', description: '', location: 'Somewhere Else', date: '2018-10-01', host_id: 1} }}.to change{Event.count}.by(0)
        end
      end
    end
  end


  context 'when user is not logged in' do

    describe 'GET #new' do
      it 'redirects to login page' do
        get :new
        expect(response).to redirect_to(login_url)
      end
    end

    describe 'POST #create' do
      it 'post is not created and user is redirected to login page' do
          expect{post :create, params: { event: { title: 'Come to my party!', description: 'The next big event description', location: 'Somewhere Else', date: '2018-10-01', host_id: 1} }}.to change{Event.count}.by(0)
          expect(response).to redirect_to(login_url)
      end
    end
  end
end
