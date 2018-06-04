require 'spec_helper'
include SessionsHelper

RSpec.describe 'events/show.html.erb' do

  before do
    Rails.application.load_seed
  end

  let(:event) { Event.where(host_id: 1).first }

  context 'when a logged in user is looking an event where they are the host' do

    before { log_in(User.first) }

    it 'displays the host name' do
      assign(:event, event)
      assign(:attendees, event.attendees.where("invites.accepted = ?", true))
      assign(:invited, event.attendees.where("invites.accepted = ?", false))
      render
      expect(rendered).to have_text('Invite people')
    end

  end

  context 'when a logged in user is looking an event where they are NOT the host' do

    before { log_in(User.second) }

    it 'displays the host name' do
      assign(:event, event)
      assign(:attendees, event.attendees.where("invites.accepted = ?", true))
      assign(:invited, event.attendees.where("invites.accepted = ?", false))
      render
      expect(rendered).to_not have_text('Invite people')
    end

  end

end
