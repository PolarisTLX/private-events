require 'spec_helper'
include SessionsHelper

RSpec.describe 'events/index.html.erb' do

  before do
    Rails.application.load_seed
  end

  context 'when the user is logged in' do

    before { log_in(User.first) }

    it 'displays the host name' do
      assign(:past_events, Event.past)
      assign(:upcoming_events, Event.upcoming)
      render
      expect(rendered).to have_text('Host:')
    end

  end

  context 'when the user is not logged in' do

    it 'does not display the host name' do
      assign(:past_events, Event.past)
      assign(:upcoming_events, Event.upcoming)
      render
      expect(rendered).to_not have_text('Host:')
    end
  end

end
