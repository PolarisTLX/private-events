require 'rails_helper'
include SessionsHelper

RSpec.describe InvitesController, type: :controller do

  before do
    Rails.application.load_seed
  end

  let(:user) { User.find_by(name: 'Person1') }
  let(:event) { Event.find_by(title: 'This is the 3rd event') }

  context 'when user is logged in' do

      before { log_in(user) }

      describe 'GET #new' do
       it 'successfully shows the new invite page' do
          get :new, params: { event_id: event.id }
          expect(response).to have_http_status(:success)
        end
      end

      describe 'POST #create' do

          describe 'when new invite info is valid' do
            it 'creates the new invite and redirects back to event page' do
              expect { post :create, params: { invite: { attendee: [1, 2], event_id: event.id } } }.to change{Invite.count}.by(2)
              expect(response).to redirect_to(event)
            end
          end

          describe 'when new invite info is NOT valid' do
            it 'does NOT create a new invite' do
              expect { post :create, params: { invite: { attendee: [3], event_id: event.id } } }.to change{Invite.count}.by(0)
            end
          end

      end

      describe 'PATCH #update' do

        describe 'when user accepts an invite' do
          it 'updates the "accepted" status of the invite' do
            invite = user.invites.where(accepted: false).first
            expect { patch :update, params: { id: invite.id, attended_event_id: invite.attended_event_id, attendee_id: user.id } }.to change { user.invites.where(accepted: true).count }.by(1)
          end
        end

        describe 'when user un-accepts an invite' do
          it 'updates the "accepted" status of the invite' do
            invite = user.invites.where(accepted: true).first
            expect { patch :update, params: { id: invite.id, attended_event_id: invite.attended_event_id, attendee_id: user.id } }.to change { user.invites.where(accepted: true).count }.by(-1)
          end
        end

      end

  end

  context 'when user is not logged in' do

    describe 'GET #new' do
      it 'redirects to login page' do
        get :new, params: { event_id: event.id }
        expect(response).to redirect_to(login_url)
      end
    end

    describe 'POST #create' do
      it 'invite is not created and user is redirected to login page' do
        expect { post :create, params: { invite: { attendee: [1, 2], event_id: event.id } } }.to change{Invite.count}.by(0)
        expect(response).to redirect_to(login_url)
      end
    end

    describe 'PATCH #update' do

      describe 'when user accepts an invite' do
        it 'does NOT updates and user is redirected to login page' do
          invite = user.invites.where(accepted: false).first
          expect { patch :update, params: { id: invite.id, attended_event_id: invite.attended_event_id, attendee_id: user.id } }.to change { user.invites.where(accepted: true).count }.by(0)
          expect(response).to redirect_to(login_url)
        end
      end

      describe 'when user un-accepts an invite' do
        it 'does NOT updates and user is redirected to login page' do
          invite = user.invites.where(accepted: true).first
          expect { patch :update, params: { id: invite.id, attended_event_id: invite.attended_event_id, attendee_id: user.id } }.to change { user.invites.where(accepted: true).count }.by(0)
          expect(response).to redirect_to(login_url)
        end
      end

    end

  end

end
