require 'rails_helper'
include SessionsHelper

RSpec.describe UsersController, type: :controller do
  before do
    Rails.application.load_seed
  end

  # name: 'Person1', email:'p1@email.com', password: 'password'

  let(:user) { User.find_by(name: 'Person1') }

  context "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  context "GET #show" do
    it "returns http success" do
      get :show, params: { id: 1 }
      expect(response).to have_http_status(:success)
    end
  end
  context "GET #edit" do
    context "when user tries to access the wrong profile" do
      it "redirects user to their own profile" do
        log_in(User.first)
        get :edit, params: { id: 2 } # "id: 2" is the wrong user
        expect(response).to redirect_to(User.first)
      end
    end

    context "when correct user accesses edit page" do
      it "returns http success" do
        log_in(User.first)
        get :edit, params: { id: 1 }
        expect(response).to have_http_status(:success)
      end
    end

  end

  # NOT WORKING - Edit a user
  # context "PATCH #update" do
  #   context "when user saves an edit to their profile" do
  #     it "properly saves the changes" do
  #       log_in(User.first)
  #       patch edit_user_path(User.first), params: { user: { username: 'NewName', password: 'password', password_confirmation: 'password' } }
  #       expect(User.first.username).to eq("NewName")
  #     end
  #   end
  # end


  context "POST #create" do

    # name: 'Person1', email:'p1@email.com', password: 'password'

    context "when new user info is valid" do
      it "creates the new user, logs in the user" do

        expect{post :create, params: { user: { name: 'Person3', email: 'p3@email.com', password: 'password', password_confirmation: 'password' } }}.to change{User.count}.by(1)
        expect(logged_in?).to be true

      end
    end

    context "when new user info is invalid" do
      # render_views
      it "does NOT create a new user" do
        # pass words don't match
        expect{post :create, params: { user: { name: 'Person3', email: 'p3@email.com', password: 'password', password_confirmation: 'word' } }}.to change{User.count}.by(0)
        expect(logged_in?).to be false

      end
    end


  end

end
