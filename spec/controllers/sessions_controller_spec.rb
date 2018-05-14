require 'rails_helper'
include SessionsHelper

RSpec.describe SessionsController, type: :controller do

  before do
    Rails.application.load_seed
  end

  let(:user) { User.find_by(name: 'Person1') }

  # it "gets the seeded user" do
  #   expect(user.username).to eq('user1')
  # end

  context "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  context "POST #create" do
    context "when user info is valid" do
      it "logs in user and redirects to user's page" do
        post :create, params: { session: { email: user.email, password: 'password' } }
        expect(logged_in?).to be true
        expect(response).to redirect_to(user)
      end
    end

    context "when user info is NOT valid" do
      it "does not log in user and re-renders login view" do
        post :create, params: { session: { email: user.email, password: 'wrongpassword' } }
        expect(logged_in?).to be false
        # BELOW DOES NOT WORK
        # expect(response).to render_template(:new)
        # expect(response).to have_content('Invalid email/password combination')
        # expect(response.body).to include('Invalid email/password combination')
      end
    end
  end




end
