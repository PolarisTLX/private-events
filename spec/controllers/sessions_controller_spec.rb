require 'rails_helper'
include SessionsHelper

RSpec.describe SessionsController, type: :controller do

  before do
    Rails.application.load_seed
  end

  let(:user) { User.find_by(name: 'Person1') }

  context "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    describe 'when user info is valid' do
      describe 'User does not want to be remembered' do
        it 'logs in user and redirects to user page' do
        post :create, params: { session: { email: user.email, password: 'password', remember_me: '0' } }
        expect(logged_in?).to be true
          expect(cookies.permanent[:remember_token]).to be nil
          expect(response).to redirect_to(user)
        end
      end
      describe 'User wants to be remembered' do
        it 'logs in user, remembers user, and redirects to user page' do
          post :create, params: { session: { email: user.email, password: 'password', remember_me: '1' } }
          expect(logged_in?).to be true
          expect(cookies.permanent[:remember_token]).to_not be nil
          expect(response).to redirect_to(user)
        end
      end
    end

    describe 'when user info is NOT valid' do
      it "does not log in user and re-renders login view" do
        post :create, params: { session: { email: user.email, password: 'wrongpassword' } }
        expect(logged_in?).to be false
        expect(request.path).to eq(login_path)
        expect(flash[:danger]).to eq 'Invalid login credentials'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'logs the user out' do
      delete :destroy
      expect(logged_in?).to be false
      expect(response).to redirect_to(login_path)
    end
  end

end
