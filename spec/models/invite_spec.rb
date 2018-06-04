require 'rails_helper'

RSpec.describe Invite, type: :model do
  before do
    Rails.application.load_seed
  end

  let(:invite) { Invite.first }

  it "is valid with valid attributes" do
    expect(invite).to be_valid
  end

  context 'is not valid without a valid attendee_id' do
    it 'attendee_id is nil' do
      invite.attendee_id = nil
      expect(invite).to_not be_valid
    end
    it 'is not a valid user' do
      invite.attendee_id = 50
      expect(invite).to_not be_valid
    end
  end

  context 'is not valid without a valid attended_event_id' do
    it 'attended_event_id is nil' do
      invite.attended_event_id = nil
      expect(invite).to_not be_valid
    end
    it 'is not a valid event' do
      invite.attended_event_id = 50
      expect(invite).to_not be_valid
    end
  end

end
