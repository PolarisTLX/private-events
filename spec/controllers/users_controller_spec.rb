require 'rails_helper'
include SessionsHelper

RSpec.describe UsersController, type: :controller do

  before do
    Rails.application.load_seed
  end

  let(:user) { User.find_by(name: 'Person1') }


  context 'when logged in user' do

    before { log_in(User.first) }

    describe 'GET #new' do
      it 'redirects user to their own profile' do
        get :new
        expect(response).to redirect_to(User.first)
      end
    end
    describe 'GET #show' do
      it "returns http success" do
        get :show, params: { id: 1 }
        expect(response).to have_http_status(:success)
      end
    end
    describe 'POST #create' do
      it 'user count does not increase and redirects user to their own profile' do
        expect{post :create, params: { user: { name: 'Person10', email: 'p10@email.com', password: 'password', password_confirmation: 'password' } }}.to change{User.count}.by(0)
        expect(response).to redirect_to(User.first)
      end
    end
    describe "GET #edit" do
      describe "when user tries to access the wrong profile" do
        it "redirects user to their own profile" do
          get :edit, params: { id: 2 } # "id: 2" is the wrong user
          expect(response).to redirect_to(User.first)
        end
      end
      describe "when correct user accesses edit page" do
        it "returns http success" do
          get :edit, params: { id: 1 }
          expect(response).to have_http_status(:success)
        end
      end
    end
    describe 'PATCH #update' do
      describe 'when user saves an edit to their profile' do
        it 'properly saves the changes' do
          patch :update, params: { id: User.first.id, user: {name: 'NewName', email: 'new@email.com', password: 'password', password_confirmation: 'password'} }
          expect(User.first.name).to eq('NewName')
        end
      end
      describe 'when user tries to save an edit on someone else\'s profile' do
        it 'redirects user to their own profile' do
          patch :update, params: { id: User.second.id, user: {name: 'NewName', email: 'new@email.com', password: 'password', password_confirmation: 'password'} }
          expect(response).to redirect_to(User.first)
        end
      end
    end

  end


  context 'when guest user' do

    describe 'GET #new' do
      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
      end
    end
    describe 'GET #show' do
      it 'returns http success' do
        get :show, params: { id: 1 }
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do

      describe "when new user info is valid" do
        it "creates the new user, logs in the user" do
          expect{post :create, params: { user: { name: 'Person3', email: 'p3@email.com', password: 'password', password_confirmation: 'password' } }}.to change{User.count}.by(1)
          expect(logged_in?).to be true
        end
      end

      describe "when new user info is invalid" do
        it "does NOT create a new user" do
          expect{post :create, params: { user: { name: 'Person3', email: 'p3@email.com', password: 'password', password_confirmation: 'word' } }}.to change{User.count}.by(0)
          expect(logged_in?).to be false
        end
      end
    end

    describe 'GET #edit' do
        it 'redirects user to the login page' do
          get :edit, params: { id: 2 } # 'id: 2' is the wrong user
          expect(response).to redirect_to(login_path)
        end
      end
      describe 'PATCH #update' do
        it 'redirects user to the login page' do
          patch :update, params: { id: User.second.id, user: {name: 'NewName', email: 'new@email.com', password: 'password', password_confirmation: 'password'} }
          expect(response).to redirect_to(login_path)
        end
      end

    end

  end
