require 'spec_helper'
include SessionsHelper

RSpec.describe 'layouts/application.html.erb' do

  before do
    Rails.application.load_seed
  end

  context 'when the user is logged in' do

    before { log_in(User.first) }

    it 'displays the name and "Log out" in the navbar' do
      render
      expect(rendered).to have_text(User.first.name)
      expect(rendered).to have_text('Log out')
    end

    it 'displays "My Events" and "Members" in the sidebar' do
      render
      expect(rendered).to have_text('My Events')
      expect(rendered).to have_text('Members')
    end

  end

  context 'when the user is NOT logged in' do

    it 'displays "Log in" and "Sign up" in the navbar' do
      render
      expect(rendered).to have_text('Log in')
      expect(rendered).to have_text('Sign up')
    end

    it 'does NOT display "My Events" and "Members" in the sidebar' do
      render
      expect(rendered).to_not have_text('My Events')
      expect(rendered).to have_text('Events')
      expect(rendered).to_not have_text('Members')
    end

  end

end
